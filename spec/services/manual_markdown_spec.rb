require "rails_helper"

RSpec.describe ManualMarkdown do
  describe ".toc_entries" do
    it "extracts h3 headings with optional custom ids" do
      markdown = <<~MD
        ### Step One {#step-one}
        ### Step Two
      MD

      entries = described_class.toc_entries(markdown)

      expect(entries).to eq([
        { id: "step-one", title: "Step One" },
        { id: "step-two", title: "Step Two" }
      ])
    end
  end

  describe ".parse_front_matter" do
    it "extracts yaml metadata and body" do
      markdown = <<~MD
        ---
        title: Custom title
        specs_table: true
        ---

        Hello world.
      MD

      parsed = described_class.parse_front_matter(markdown)

      expect(parsed[:metadata]).to eq("title" => "Custom title", "specs_table" => true)
      expect(parsed[:body].strip).to eq("Hello world.")
    end
  end

  describe ".render" do
    it "renders callouts, figures, and lead paragraphs" do
      markdown = <<~MD
        Welcome aboard.

        ::: warn Safety First
        Disconnect power first.
        :::

        ### Setup {#setup}

        ::: figure
        ![Board photo](baldrick8/board-power.png)

        - Port 1 powers pixels 1-4
        :::
      MD

      html = described_class.render(markdown)

      expect(html).to include('class="lead"')
      expect(html).to include('class="callout warn"')
      expect(html).to include("<h3 id=\"setup\">Setup</h3>")
      expect(html).to include('class="figure"')
      expect(html).to include('baldrick8/board-power.png')
    end

    it "wraps standalone images in a doc-photo frame" do
      markdown = <<~MD
        Intro text.

        ![Board photo](baldrick8/breakdown11.jpg)
      MD

      html = described_class.render(markdown)

      expect(html).to include('<div class="doc-photo">')
      expect(html).not_to include('<p><img')
    end
  end
end
