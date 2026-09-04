require "rails_helper"
require "zip"

RSpec.describe Triage::XlightsShowParser do
  def write_show_zip(path, networks:, effects:, extra_networks: nil)
    FileUtils.mkdir_p(File.dirname(path))
    File.delete(path) if File.exist?(path)
    Zip::File.open(path, Zip::File::CREATE) do |zip|
      zip.get_output_stream("show/xlights_networks.xml") { |f| f.write(networks) }
      zip.get_output_stream("show/xlights_rgbeffects.xml") { |f| f.write(effects) }
      zip.get_output_stream("show/Backup/OnStart/xlights_networks.xml") { |f| f.write(extra_networks) } if extra_networks
      zip.get_output_stream("__MACOSX/show/._xlights_networks.xml") { |f| f.write("junk") }
    end
  end

  let(:networks_xml) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <Networks>
        <Controller Id="1" Name="Right-FPP" Vendor="FPP" Model="FPP Player Only" IP="right-fpp.local" Protocol="Player Only" ActiveState="xLights Only" />
        <Controller Id="8" Name="B17-5" Description="ILightThat-Baldrick17" Vendor="ILightThat" Model="Baldrick17" IP="192.168.72.42" Protocol="DDP" ActiveState="Active">
          <network ChannelsPerPacket="1440" MaxChannels="38250" NetworkType="DDP" Enabled="Yes" />
        </Controller>
      </Networks>
    XML
  end

  let(:effects_xml) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <xrgb>
        <models>
          <model name="Matrix" DisplayAs="Matrix" Controller="B17-5" NumStrings="17" NodesPerString="750" StringType="RGB Nodes" StartChannel="!B17-5:1">
            <ControllerConnection Port="1" Protocol="ws2811"/>
          </model>
          <model name="Other" DisplayAs="Tree" Controller="Right-FPP" NumStrings="1" NodesPerString="50" StringType="RGB Nodes" StartChannel="!Right-FPP:1" />
        </models>
        <view_objects>
          <view_object name="Controller: B17-5" Controller="B17-5" DisplayAs="Controller" />
        </view_objects>
      </xrgb>
    XML
  end

  it "extracts ILightThat controllers and matching props, ignoring FPP, Backup, and view objects" do
    zip_path = Rails.root.join("tmp", "xlights_parser_spec.zip")
    write_show_zip(zip_path, networks: networks_xml, effects: effects_xml, extra_networks: "<Networks></Networks>")

    result = described_class.parse(zip_path.to_s)

    expect(result["error"]).to be_blank
    expect(result["controllers"].length).to eq(1)

    controller = result["controllers"].first
    expect(controller["name"]).to eq("B17-5")
    expect(controller["model"]).to eq("Baldrick17")
    expect(controller["ip"]).to eq("192.168.72.42")
    expect(controller["network"]["MaxChannels"]).to eq("38250")
    expect(controller["props"].length).to eq(1)
    expect(controller["props"].first["name"]).to eq("Matrix")
    expect(controller["props"].first["port"]).to eq("1")
    expect(controller["props"].first["pixel_protocol"]).to eq("ws2811")
    expect(controller["props"].first["channels"]).to eq(17 * 750 * 3)
  ensure
    File.delete(zip_path) if zip_path && File.exist?(zip_path)
  end

  it "returns an error when the zip has no networks XML" do
    zip_path = Rails.root.join("tmp", "xlights_parser_empty.zip")
    FileUtils.mkdir_p(File.dirname(zip_path))
    File.delete(zip_path) if File.exist?(zip_path)
    Zip::File.open(zip_path, Zip::File::CREATE) do |zip|
      zip.get_output_stream("readme.txt") { |f| f.write("no xml here") }
    end

    result = described_class.parse(zip_path.to_s)
    expect(result["error"]).to include("xlights_networks.xml")
  ensure
    File.delete(zip_path) if zip_path && File.exist?(zip_path)
  end
end
