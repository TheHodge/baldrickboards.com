module Triage
  class MattermostNotifier
    IGNORED_CHANGE_KEYS = %w[
      updated_at
      todoist_synced_at
      todoist_last_event_at
      todoist_sync_status
      todoist_sync_error
    ].freeze

    class << self
      def case_created(case_record)
        return unless notify?(case_record)

        message = [
          "### New Christmas Triage case ##{case_record.case_number}",
          "",
          "**Name:** #{case_record.name}",
          "**Email:** #{case_record.email}",
          "**Status:** #{case_record.status}",
          "",
          truncate(case_record.problem_summary.presence || case_record.problem_description),
          "",
          todoist_link(case_record)
        ].join("\n")

        post(message)
      end

      def case_updated(case_record, changes: nil)
        return unless notify?(case_record)

        change_lines = format_changes(changes || case_record.saved_changes)
        return if change_lines.blank?

        message = [
          "### Christmas Triage case ##{case_record.case_number} updated",
          "",
          *change_lines,
          "",
          "**Current status:** #{case_record.status}",
          "",
          todoist_link(case_record)
        ].join("\n")

        post(message)
      end

      def comment_added(case_record, comment)
        return unless notify?(case_record)

        message = [
          "### New comment on case ##{case_record.case_number}",
          "",
          "**From:** #{comment.admin_name}",
          "",
          truncate(comment.content),
          "",
          todoist_link(case_record)
        ].join("\n")

        post(message)
      end

      private

      def notify?(case_record)
        return false unless Mattermost::Config.enabled?
        return false if case_record.todoist_task_id.blank?

        true
      end

      def post(message)
        Mattermost::Client.new.create_post!(message: message)
      rescue Mattermost::Client::Error => e
        Rails.logger.error("[MattermostNotifier] #{e.message}")
      end

      def todoist_link(case_record)
        url = Todoist::TaskLink.url_for(case_record)
        return "_Todoist link unavailable_" if url.blank?

        "[Open in Todoist](#{url})"
      end

      def format_changes(changes)
        changes.each_with_object([]) do |(key, values), lines|
          next if IGNORED_CHANGE_KEYS.include?(key)

          from, to = Array(values)
          lines << "**#{key.humanize}:** #{from.inspect} → #{to.inspect}"
        end
      end

      def truncate(text, length: 500)
        str = text.to_s
        return str if str.length <= length

        "#{str[0, length]}…"
      end
    end
  end
end
