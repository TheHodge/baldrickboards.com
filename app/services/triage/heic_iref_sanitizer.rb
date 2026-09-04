# frozen_string_literal: true

require "securerandom"
require "tmpdir"

module Triage
  # iOS 18 HEIC files often attach portrait/depth auxiliaries to a `tmap`
  # (HDR gain-map) item. libheif 1.17 then aborts with:
  #   Non-existing depth image referenced
  # Retarget those iref destinations onto a real image item so the primary
  # still can be decoded without upgrading libheif.
  class HeicIrefSanitizer
    IMAGE_TYPES = %w[hvc1 avc1 av01 jpeg grid msf1].freeze

    def self.sanitize_to_tempfile(path)
      new(path).sanitize_to_tempfile
    end

    def initialize(path)
      @path = path
    end

    def sanitize_to_tempfile
      data = File.binread(@path)
      patched = patch(data.dup)
      return if patched.nil? || patched == data

      path = File.join(Dir.tmpdir, "heic-sanitized-#{Process.pid}-#{SecureRandom.hex(8)}.heic")
      File.binwrite(path, patched)
      path
    end

    def patch(data)
      meta = find_box(data, 0, data.bytesize, "meta")
      return unless meta

      meta_payload_start = meta[:start] + meta[:hdr] + 4
      meta_end = meta[:start] + meta[:size]

      pitm = nil
      tmap_ids = []
      image_ids = []
      iref = nil

      each_box(data, meta_payload_start, meta_end) do |box|
        case box[:type]
        when "pitm"
          pitm = read_fullbox_item_id(data, box)
        when "iinf"
          each_infe(data, box) do |item_id, item_type|
            tmap_ids << item_id if item_type == "tmap"
            image_ids << item_id if IMAGE_TYPES.include?(item_type)
          end
        when "iref"
          iref = box
        end
      end

      return data if iref.nil? || tmap_ids.empty?

      rewrite_iref!(data, iref, tmap_ids, image_ids, pitm)
      data
    rescue StandardError => e
      Rails.logger.info("[Triage::HeicIrefSanitizer] #{e.class}: #{e.message}")
      nil
    end

    private

    def find_box(data, start_pos, end_pos, type)
      each_box(data, start_pos, end_pos) do |box|
        return box if box[:type] == type
      end
      nil
    end

    def each_box(data, start_pos, end_pos)
      pos = start_pos
      while pos + 8 <= end_pos
        box = read_box(data, pos, end_pos)
        break unless box

        yield box
        pos = box[:start] + box[:size]
      end
    end

    def read_box(data, pos, end_pos)
      return if pos + 8 > end_pos

      size = data[pos, 4].unpack1("N")
      type = data[pos + 4, 4]
      hdr = 8
      if size == 1
        return if pos + 16 > end_pos

        size = data[pos + 8, 8].unpack1("Q>")
        hdr = 16
      elsif size == 0
        size = end_pos - pos
      end
      return if size < hdr || pos + size > end_pos

      { start: pos, size: size, hdr: hdr, type: type }
    end

    def read_fullbox_item_id(data, box)
      version = data[box[:start] + box[:hdr]].ord
      payload = box[:start] + box[:hdr] + 4
      if version == 0
        data[payload, 2].unpack1("n")
      else
        data[payload, 4].unpack1("N")
      end
    end

    def each_infe(data, iinf)
      version = data[iinf[:start] + iinf[:hdr]].ord
      pos = iinf[:start] + iinf[:hdr] + 4
      count = if version == 0
        data[pos, 2].unpack1("n")
      else
        data[pos, 4].unpack1("N")
      end
      pos += version == 0 ? 2 : 4
      limit = iinf[:start] + iinf[:size]

      count.times do
        break if pos + 8 > limit

        box = read_box(data, pos, limit)
        break unless box && box[:type] == "infe"

        infe_version = data[box[:start] + box[:hdr]].ord
        payload = box[:start] + box[:hdr] + 4
        if infe_version >= 2
          if infe_version == 2
            item_id = data[payload, 2].unpack1("n")
            item_type = data[payload + 4, 4]
          else
            item_id = data[payload, 4].unpack1("N")
            item_type = data[payload + 6, 4]
          end
          yield item_id, item_type
        end
        pos = box[:start] + box[:size]
      end
    end

    def rewrite_iref!(data, iref, tmap_ids, image_ids, pitm)
      version = data[iref[:start] + iref[:hdr]].ord
      pos = iref[:start] + iref[:hdr] + 4
      limit = iref[:start] + iref[:size]
      id_width = version == 0 ? 2 : 4
      unpack = version == 0 ? "n" : "N"
      pack = version == 0 ? "n" : "N"

      while pos + 8 <= limit
        box = read_box(data, pos, limit)
        break unless box

        from_off = box[:start] + box[:hdr]
        count_off = from_off + id_width
        break if count_off + 2 > box[:start] + box[:size]

        count = data[count_off, 2].unpack1("n")
        refs_off = count_off + 2
        refs = count.times.map { |i| data[refs_off + (i * id_width), id_width].unpack1(unpack) }

        if refs.any? { |ref| tmap_ids.include?(ref) }
          used = refs - tmap_ids
          refs.each_with_index do |ref, i|
            next unless tmap_ids.include?(ref)

            substitute = (image_ids - used - tmap_ids).first ||
              (image_ids - tmap_ids).first ||
              pitm
            next if substitute.nil?

            data[refs_off + (i * id_width), id_width] = [substitute].pack(pack)
            used << substitute
          end
        end

        pos = box[:start] + box[:size]
      end
    end
  end
end
