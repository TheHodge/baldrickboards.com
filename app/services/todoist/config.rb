module Todoist
  module Config
    module_function

    def enabled?
      ENV.fetch("TODOIST_SYNC_ENABLED", "false") == "true"
    end

    def api_token
      ENV["TODOIST_API_TOKEN"].presence || Rails.application.credentials[:todoist_api_token]
    end

    def webhook_secret
      ENV["TODOIST_WEBHOOK_SECRET"].presence || Rails.application.credentials[:todoist_webhook_secret]
    end

    def workspace_name
      ENV.fetch("TODOIST_WORKSPACE_NAME", "iLightThat")
    end

    def project_name
      ENV.fetch("TODOIST_PROJECT_NAME", "Support Issues")
    end

    def needs_reply_label
      "triage-needs-reply"
    end

    def base_url
      ENV.fetch("TODOIST_API_BASE_URL", "https://api.todoist.com/api/v1")
    end
  end
end
