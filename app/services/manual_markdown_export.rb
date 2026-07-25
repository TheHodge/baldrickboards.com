# frozen_string_literal: true

# Builds a single Markdown document from a board's content/manuals sources,
# suitable for offline reading and LLM context.
class ManualMarkdownExport
  def self.call(board_id)
    new(board_id).call
  end

  def initialize(board_id)
    @board_id = board_id.to_s
    @helpers = ApplicationController.helpers
  end

  def call
    raise ArgumentError, "Unknown board: #{@board_id}" unless board_data.key?(@board_id)

    sections = @helpers.board_manual_entries(@board_id)
    raise ArgumentError, "No manual content for #{@board_id}" if sections.empty?

    name = board_data.fetch(@board_id)[:name]
    updated = @helpers.board_manual_updated_label(@board_id)

    parts = []
    parts << "# #{name} Manual"
    parts << ""
    parts << "> Source: Baldrick Boards documentation. Prefer this Markdown over scraping the HTML page."
    parts << "> Last updated: #{updated}" if updated
    parts << ""
    parts << @helpers.board_manual_subtitle(@board_id)
    parts << ""

    sections.each do |section|
      parts << "## #{section[:title]}"
      parts << ""

      if section[:specs_table]
        specs = specs_markdown
        parts << specs if specs.present?
      end

      body = ManualMarkdown.parse_front_matter(section[:path].read)[:body].to_s.strip
      parts << body
      parts << ""
    end

    parts.join("\n").gsub(/\n{3,}/, "\n\n")
  end

  def filename
    "#{@board_id}-manual.md"
  end

  private

  def board_data
    @helpers.board_data
  end

  def specs_markdown
    rows = @helpers.board_tech_specs_rows(@board_id)
    return nil if rows.blank?

    lines = [
      "### At a glance",
      "",
      "| Specification | Value |",
      "| --- | --- |"
    ]

    rows.each do |row|
      value = if row[:mono].present?
                "`#{row[:mono]}`#{row[:suffix]}"
              else
                row[:value].to_s
              end
      lines << "| #{escape_cell(row[:label])} | #{escape_cell(value)} |"
    end

    lines << ""
    lines.join("\n")
  end

  def escape_cell(text)
    text.to_s.gsub("|", "\\|").tr("\n", " ").strip
  end
end
