module Triage
  class MattermostNotifier
    IGNORED_CHANGE_KEYS = %w[
      updated_at
      todoist_synced_at
      todoist_last_event_at
      todoist_sync_status
      todoist_sync_error
      mattermost_root_post_id
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

        post_for_case(case_record, message, as_root: true)
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

        post_for_case(case_record, message)
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

        post_for_case(case_record, message)
      end

      private

      def notify?(case_record)
        return false unless Mattermost::Config.enabled?
        return false if case_record.todoist_task_id.blank?

        true
      end

      def post_for_case(case_record, message, as_root: false)
        root_id = case_record.mattermost_root_post_id
        # New cases always start a top-level post. Follow-ups reply in that thread
        # when we have a root id; otherwise post top-level and adopt it as root
        # (covers pre-threading cases that have no stored Mattermost post id).
        reply_root_id = as_root ? nil : root_id.presence

        response = create_post_with_optional_root!(message, reply_root_id, case_record)
        return if response.nil?

        persist_root_post_id!(case_record, response) if as_root || case_record.mattermost_root_post_id.blank?
        response
      end

      def create_post_with_optional_root!(message, root_id, case_record)
        Mattermost::Client.new.create_post!(message: message, root_id: root_id)
      rescue Mattermost::Client::Error => e
        # Stale/deleted root posts on older cases should not block notifications.
        if root_id.present?
          Rails.logger.warn(
            "[MattermostNotifier] Thread reply failed for case ##{case_record.case_number} " \
            "(root_id=#{root_id}): #{e.message}; falling back to a new top-level post"
          )
          clear_root_post_id!(case_record)
          begin
            return Mattermost::Client.new.create_post!(message: message, root_id: nil)
          rescue Mattermost::Client::Error => fallback_error
            Rails.logger.error("[MattermostNotifier] #{fallback_error.message}")
            return nil
          end
        end

        Rails.logger.error("[MattermostNotifier] #{e.message}")
        nil
      end

      def persist_root_post_id!(case_record, response)
        post_id = response.is_a?(Hash) ? response["id"] : nil
        return if post_id.blank?
        return if case_record.mattermost_root_post_id == post_id

        case_record.update_column(:mattermost_root_post_id, post_id)
      end

      def clear_root_post_id!(case_record)
        return if case_record.mattermost_root_post_id.blank?

        case_record.update_column(:mattermost_root_post_id, nil)
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
