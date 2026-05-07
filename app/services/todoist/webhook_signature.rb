require "openssl"
require "base64"

module Todoist
  module WebhookSignature
    module_function

    def valid?(payload:, provided_signature:)
      secret = Todoist::Config.webhook_secret
      return false if secret.blank? || provided_signature.blank?

      normalized_signature = provided_signature.to_s.sub(/\Asha256=/, "")
      expected_hex = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
      expected_base64 = Base64.strict_encode64(OpenSSL::HMAC.digest("SHA256", secret, payload))

      secure_compare(expected_hex, normalized_signature) ||
        secure_compare(expected_base64, normalized_signature)
    end

    def secure_compare(a, b)
      ActiveSupport::SecurityUtils.secure_compare(a.to_s, b.to_s)
    rescue StandardError
      false
    end
  end
end
