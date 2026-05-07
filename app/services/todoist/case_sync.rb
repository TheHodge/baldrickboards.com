module Todoist
  class CaseSync
    class << self
      def sync_create(case_record)
        return unless Todoist::Config.enabled?

        client = Todoist::Client.new
        project_id = case_record.todoist_project_id.presence || client.resolve_project_id!(
          workspace_name: Todoist::Config.workspace_name,
          project_name: Todoist::Config.project_name
        )

        task = client.create_task!(
          project_id: project_id,
          content: task_title(case_record),
          description: task_description(case_record)
        )

        case_record.update!(
          todoist_task_id: task.fetch("id").to_s,
          todoist_project_id: project_id,
          todoist_synced_at: Time.current,
          todoist_sync_status: "synced",
          todoist_sync_error: nil
        )

        sync_attachments(case_record, client)
      rescue StandardError => e
        mark_sync_error(case_record, e)
      end

      def sync_comment(case_record, comment)
        return unless syncable_case?(case_record)

        client = Todoist::Client.new
        client.create_comment!(
          task_id: case_record.todoist_task_id,
          content: "Admin comment from #{comment.admin_name}: #{comment.content}"
        )
        touch_synced(case_record)
      rescue StandardError => e
        mark_sync_error(case_record, e)
      end

      def sync_status(case_record, status)
        return unless syncable_case?(case_record)

        client = Todoist::Client.new
        if status == "closed"
          client.close_task!(task_id: case_record.todoist_task_id)
        elsif status == "open"
          client.reopen_task!(task_id: case_record.todoist_task_id)
        else
          client.update_task!(
            task_id: case_record.todoist_task_id,
            attributes: { description: "#{task_description(case_record)}\n\nStatus: #{status}" }
          )
        end
        touch_synced(case_record)
      rescue StandardError => e
        mark_sync_error(case_record, e)
      end

      def sync_delete(case_record)
        return unless syncable_case?(case_record)

        Todoist::Client.new.delete_task!(task_id: case_record.todoist_task_id)
      rescue StandardError => e
        Rails.logger.error("[Todoist] Failed deleting task for case ##{case_record.case_number}: #{e.message}")
      end

      private

      def sync_attachments(case_record, client)
        case_record.media.each do |attachment|
          attachment.blob.open do |file|
            uploaded = client.upload_file!(
              io: file,
              filename: attachment.filename.to_s,
              content_type: attachment.blob.content_type || "application/octet-stream"
            )
            client.create_comment!(
              task_id: case_record.todoist_task_id,
              content: "Attachment uploaded from Christmas Triage",
              attachment: uploaded
            )
          end
        end

        return if case_record.system_state.blank?

        Tempfile.create(["case-#{case_record.case_number}-system-state", ".txt"]) do |tmp|
          tmp.write(case_record.system_state)
          tmp.rewind

          uploaded = client.upload_file!(
            io: tmp,
            filename: "case-#{case_record.case_number}-system-state.txt",
            content_type: "text/plain"
          )
          client.create_comment!(
            task_id: case_record.todoist_task_id,
            content: "System state attached from Christmas Triage",
            attachment: uploaded
          )
        end

        touch_synced(case_record)
      end

      def task_title(case_record)
        "Triage ##{case_record.case_number} - #{case_record.problem_summary.presence || case_record.problem_description.to_s.truncate(80)}"
      end

      def task_description(case_record)
        [
          "Name: #{case_record.name}",
          "Email: #{case_record.email}",
          "Status: #{case_record.status}",
          "Boards: #{Array(case_record.affected_boards).join(', ')}",
          "Versions: Baldrick #{case_record.baldrick_version}, FPP #{case_record.fpp_version}, xLights #{case_record.xlights_version}",
          "OS: #{case_record.operating_system}",
          "",
          "Problem:",
          case_record.problem_description
        ].join("\n")
      end

      def touch_synced(case_record)
        case_record.update_columns(
          todoist_synced_at: Time.current,
          todoist_sync_status: "synced",
          todoist_sync_error: nil
        )
      end

      def mark_sync_error(case_record, error)
        Rails.logger.error("[Todoist] Sync failure for case ##{case_record.case_number}: #{error.message}")
        case_record.update_columns(todoist_sync_status: "failed", todoist_sync_error: error.message)
      rescue StandardError
        nil
      end

      def syncable_case?(case_record)
        Todoist::Config.enabled? && case_record.todoist_task_id.present?
      end
    end
  end
end
