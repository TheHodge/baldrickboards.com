class Integrations::TodoistWebhooksController < ActionController::API
  def verify
    head :ok
  end

  def create
    raw_payload = request.raw_post
    signature = request.headers["X-Todoist-Hmac-SHA256"]

    unless Todoist::WebhookSignature.valid?(payload: raw_payload, provided_signature: signature)
      render json: { error: "invalid signature" }, status: :unauthorized
      return
    end

    payload = JSON.parse(raw_payload)
    Todoist::WebhookProcessor.process!(payload)

    render json: { ok: true }, status: :ok
  rescue JSON::ParserError
    render json: { error: "invalid json payload" }, status: :bad_request
  rescue StandardError => e
    Rails.logger.error("[TodoistWebhook] #{e.class}: #{e.message}")
    render json: { error: "processing failed" }, status: :unprocessable_entity
  end
end
