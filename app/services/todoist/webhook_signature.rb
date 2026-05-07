require "openssl"

module Todoist
  module WebhookSignature
    module_function

    def valid?(payload:, provided_signature:)
      secret = Todoist::Config.webhook_secret
      return false if secret.blank? || provided_signature.blank?

      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
      secure_compare(expected, provided_signature)
    end

    def secure_compare(a, b)
      ActiveSupport::SecurityUtils.secure_compare(a.to_s, b.to_s)
    rescue StandardError
      false
    end
  end
end
