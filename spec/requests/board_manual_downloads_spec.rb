require "rails_helper"

RSpec.describe "Board manual downloads", type: :request do
  describe "GET /en/boards/:board/manual.md" do
    it "returns the markdown manual" do
      get board_manual_markdown_path("baldrick8", locale: :en)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/markdown")
      expect(response.headers["Content-Disposition"]).to include("baldrick8-manual.md")
      expect(response.body).to include("# Baldrick8 Manual")
    end

    it "returns not found for unknown boards" do
      get board_manual_markdown_path("nope", locale: :en)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /en/boards/:board/manual.pdf" do
    it "returns a generated PDF" do
      pdf_bytes = "%PDF-1.4 fake"
      allow(::Grover).to receive(:new).and_return(instance_double(::Grover, to_pdf: pdf_bytes))

      get board_manual_pdf_path("baldrick8", locale: :en)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/pdf")
      expect(response.headers["Content-Disposition"]).to include("baldrick8-manual.pdf")
      expect(response.body).to eq(pdf_bytes)
    end

    it "redirects with a flash when PDF generation fails" do
      allow(::Grover).to receive(:new).and_raise(::Grover::Error, "chromium missing")

      get board_manual_pdf_path("baldrick8", locale: :en)

      expect(response).to redirect_to(board_page_path("baldrick8", "manual", locale: :en))
      follow_redirect!
      expect(response.body).to include("PDF generation is temporarily unavailable")
    end
  end
end
