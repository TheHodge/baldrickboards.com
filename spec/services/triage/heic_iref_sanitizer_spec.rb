require "rails_helper"

RSpec.describe Triage::HeicIrefSanitizer do
  def box(type, payload)
    [8 + payload.bytesize].pack("N") + type + payload
  end

  def full_box(type, version, payload)
    box(type, [version].pack("C") + "\x00\x00\x00" + payload)
  end

  def infe(item_id, item_type)
    full_box("infe", 2, [item_id].pack("n") + "\x00\x00" + item_type + "\x00")
  end

  def ref_box(type, from_id, refs)
    body = [from_id].pack("n") + [refs.length].pack("n") + refs.pack("n*")
    box(type, body)
  end

  def heic_with_tmap_aux
    ftyp = box("ftyp", "heic" + "\x00\x00\x00\x00" + "mif1heic")
    pitm = full_box("pitm", 0, [1].pack("n"))
    iinf = full_box("iinf", 0, [3].pack("n") + infe(1, "hvc1") + infe(4, "hvc1") + infe(2, "tmap"))
    iref = full_box("iref", 0, ref_box("auxl", 3, [1, 2]))
    meta = full_box("meta", 0, pitm + iinf + iref)
    ftyp + meta
  end

  it "retargets tmap auxiliary destinations onto a real image item" do
    data = heic_with_tmap_aux
    patched = described_class.new("/dev/null").patch(data.dup)
    auxl_at = patched.index("auxl")
    refs = patched[auxl_at + 8, 4].unpack("n*")

    expect(patched).not_to eq(data)
    expect(refs).to eq([1, 4])
  end

  it "leaves files without a tmap item unchanged" do
    ftyp = box("ftyp", "heic" + "\x00\x00\x00\x00" + "mif1heic")
    pitm = full_box("pitm", 0, [1].pack("n"))
    iinf = full_box("iinf", 0, [1].pack("n") + infe(1, "hvc1"))
    iref = full_box("iref", 0, ref_box("auxl", 3, [1]))
    meta = full_box("meta", 0, pitm + iinf + iref)
    data = ftyp + meta

    expect(described_class.new("/dev/null").patch(data.dup)).to eq(data)
  end
end
