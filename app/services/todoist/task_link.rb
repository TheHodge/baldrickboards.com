module Todoist
  module TaskLink
    module_function

    def url_for(case_record)
      task_id = case_record.todoist_task_id
      return if task_id.blank?

      if Todoist::Config.enabled? && Todoist::Config.api_token.present?
        task = Todoist::Client.new.get_task!(task_id: task_id)
        task["url"].presence || fallback_url(task_id)
      else
        fallback_url(task_id)
      end
    rescue Todoist::Client::Error => e
      Rails.logger.warn("[Todoist::TaskLink] Failed fetching task #{task_id}: #{e.message}")
      fallback_url(task_id)
    end

    def fallback_url(task_id)
      "https://app.todoist.com/app/task/#{task_id}"
    end
  end
end
