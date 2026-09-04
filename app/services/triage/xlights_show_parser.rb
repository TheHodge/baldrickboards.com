require "zip"

module Triage
  class XlightsShowParser
    XML_MAX_BYTES = 20.megabytes
    VENDOR_PATTERN = /ilightthat/i
    SKIP_PATH_PARTS = %w[__macosx backup].freeze

    def self.parse(path)
      new(path).parse
    end

    def initialize(path)
      @path = path
    end

    def parse
      Zip::File.open(@path) do |zip|
        networks_xml = read_xml(zip, "xlights_networks.xml")
        return { "error" => "Could not find xlights_networks.xml in the zip." } if networks_xml.blank?

        effects_xml = read_xml(zip, "xlights_rgbeffects.xml")
        controllers = parse_controllers(networks_xml)
        return { "error" => "No ILightThat controllers found in xlights_networks.xml." } if controllers.empty?

        attach_props!(controllers, effects_xml) if effects_xml.present?

        { "controllers" => controllers }
      end
    rescue Zip::Error => e
      { "error" => "Could not read the zip file: #{e.message}" }
    rescue StandardError => e
      Rails.logger.warn("[Triage::XlightsShowParser] #{e.class}: #{e.message}")
      { "error" => "Could not parse the xLights show folder: #{e.message}" }
    end

    private

    def read_xml(zip, basename)
      entry = find_entry(zip, basename)
      return if entry.blank?
      return if entry.size > XML_MAX_BYTES

      entry.get_input_stream.read
    end

    def find_entry(zip, basename)
      candidates = zip.entries.select do |entry|
        next false if entry.directory?
        next false unless File.basename(entry.name) == basename
        next false if skipped_path?(entry.name)

        true
      end

      candidates.min_by { |entry| entry.name.count("/") }
    end

    def skipped_path?(name)
      name.split(%r{[/\\]}).any? { |part| SKIP_PATH_PARTS.include?(part.downcase) }
    end

    def parse_controllers(xml)
      doc = Nokogiri::XML(xml)
      doc.xpath("//Controller").filter_map do |node|
        vendor = node["Vendor"].to_s
        next unless vendor.match?(VENDOR_PATTERN)

        {
          "id" => node["Id"],
          "name" => node["Name"],
          "description" => node["Description"],
          "vendor" => vendor,
          "model" => node["Model"],
          "ip" => node["IP"],
          "protocol" => node["Protocol"],
          "active_state" => node["ActiveState"],
          "network" => child_attributes(node.at_xpath("./network")),
          "props" => []
        }
      end
    end

    def attach_props!(controllers, xml)
      names = controllers.to_h { |controller| [controller["name"], controller] }
      doc = Nokogiri::XML(xml)

      doc.xpath("//model[@Controller]").each do |node|
        controller = names[node["Controller"].to_s]
        next unless controller

        connection = node.at_xpath("./ControllerConnection")
        num_strings = node["NumStrings"].to_i
        nodes_per_string = node["NodesPerString"].to_i
        string_type = node["StringType"].to_s
        channels = num_strings * nodes_per_string
        channels *= 3 if string_type.match?(/rgb/i)

        controller["props"] << {
          "name" => node["name"],
          "display_as" => node["DisplayAs"],
          "num_strings" => node["NumStrings"],
          "nodes_per_string" => node["NodesPerString"],
          "string_type" => string_type,
          "start_channel" => node["StartChannel"],
          "port" => connection&.[]("Port"),
          "pixel_protocol" => connection&.[]("Protocol"),
          "channels" => channels.positive? ? channels : nil
        }
      end
    end

    def child_attributes(node)
      return {} unless node

      node.attributes.transform_values(&:value)
    end
  end
end
