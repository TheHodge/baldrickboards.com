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

        set_needs_reply_label(case_record, client, enabled: true)
        sync_attachments(case_record, client)
        sync_initial_status(case_record, client)
      rescue StandardError => e
        mark_sync_error(case_record, e)
      end

      def sync_comment(case_record, comment, source: "Admin comment", attachments: [])
        return unless syncable_case?(case_record)

        client = Todoist::Client.new
        client.create_comment!(
          task_id: case_record.todoist_task_id,
          content: "#{source} from #{comment.admin_name}: #{comment.content}"
        )

        Array(attachments).each do |attachment|
          attachment.blob.open do |file|
            uploaded = client.upload_file!(
              io: file,
              filename: attachment.filename.to_s,
              content_type: attachment.blob.content_type || "application/octet-stream"
            )
            client.create_comment!(
              task_id: case_record.todoist_task_id,
              content: "Attachment uploaded from Christmas Triage reply",
              attachment: uploaded
            )
          end
        end

        set_needs_reply_label(case_record, client, enabled: source == "User reply")
        touch_synced(case_record)
      rescue StandardError => e
        mark_sync_error(case_record, e)
      end

      def sync_solution(case_record)
        return unless syncable_case?(case_record)

        content = solution_comment_content(case_record)
        return if content.blank?

        client = Todoist::Client.new
        client.create_comment!(
          task_id: case_record.todoist_task_id,
          content: content
        )
        touch_synced(case_record)
      rescue StandardError => e
        mark_sync_error(case_record, e)
      end

      def sync_status(case_record, status)
        return unless syncable_case?(case_record)

        client = Todoist::Client.new
        if %w[solved closed].include?(status)
          client.close_task!(task_id: case_record.todoist_task_id)
          set_needs_reply_label(case_record, client, enabled: false)
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

        if case_record.debugging_file.attached?
          case_record.debugging_file.blob.open do |file|
            uploaded = client.upload_file!(
              io: file,
              filename: case_record.debugging_file.filename.to_s,
              content_type: case_record.debugging_file.blob.content_type || "application/octet-stream"
            )
            client.create_comment!(
              task_id: case_record.todoist_task_id,
              content: "Debugging file attached from Christmas Triage",
              attachment: uploaded
            )
          end
        end

        if case_record.system_state.present?
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
        end

        if case_record.xlights_summary.present?
          Tempfile.create(["case-#{case_record.case_number}-xlights-summary", ".txt"]) do |tmp|
            tmp.write(xlights_summary_text(case_record))
            tmp.rewind

            uploaded = client.upload_file!(
              io: tmp,
              filename: "case-#{case_record.case_number}-xlights-summary.txt",
              content_type: "text/plain"
            )
            client.create_comment!(
              task_id: case_record.todoist_task_id,
              content: "xLights ILightThat summary attached from Christmas Triage",
              attachment: uploaded
            )
          end
        end

        touch_synced(case_record)
      end

      def sync_initial_status(case_record, client)
        return if case_record.open?

        client.close_task!(task_id: case_record.todoist_task_id)
        set_needs_reply_label(case_record, client, enabled: false)
        touch_synced(case_record)
      end

      def clear_needs_reply_label(case_record)
        return unless syncable_case?(case_record)

        client = Todoist::Client.new
        set_needs_reply_label(case_record, client, enabled: false)
        touch_synced(case_record)
      rescue StandardError => e
        mark_sync_error(case_record, e)
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
          "Tried solutions: #{case_record.tried_solutions.presence || 'Not provided'}",
          "",
          "Problem:",
          case_record.problem_description
        ].join("\n")
      end

      def solution_comment_content(case_record)
        if case_record.custom_solution.present?
          "Solution from Christmas Triage: #{case_record.custom_solution}"
        elsif case_record.solved_by_solution_id.present?
          solution = case_record.solved_by_solution || Solution.find_by(id: case_record.solved_by_solution_id)
          return if solution.blank?

          "Solution from Christmas Triage (#{solution.problem_title}): #{solution.solution_text}"
        end
      end

      def xlights_summary_text(case_record)
        summary = case_record.xlights_summary
        return summary.to_s unless summary.is_a?(Hash)
        return "Parse error: #{summary["error"]}" if summary["error"].present?

        lines = ["ILightThat controllers from uploaded xLights show folder:"]
        Array(summary["controllers"]).each do |controller|
          lines << ""
          lines << "#{controller["name"]} (#{controller["model"]}) #{controller["ip"]} #{controller["protocol"]} #{controller["active_state"]}"
          if controller["network"].present?
            lines << "  network: #{controller["network"].map { |k, v| "#{k}=#{v}" }.join(", ")}"
          end
          Array(controller["props"]).each do |prop|
            lines << "  - #{prop["name"]}: port #{prop["port"]} #{prop["pixel_protocol"]} #{prop["num_strings"]}x#{prop["nodes_per_string"]} #{prop["start_channel"]} (#{prop["channels"]} ch)"
          end
        end
        lines.join("\n")
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

      def set_needs_reply_label(case_record, client, enabled:)
        task = client.get_task!(task_id: case_record.todoist_task_id)
        existing_labels = Array(task["labels"]).map(&:to_s)
        label = Todoist::Config.needs_reply_label
        updated_labels = if enabled
          (existing_labels + [label]).uniq
        else
          existing_labels - [label]
        end
        return if updated_labels.sort == existing_labels.sort

        client.update_task!(
          task_id: case_record.todoist_task_id,
          attributes: { labels: updated_labels }
        )
      end

      def syncable_case?(case_record)
        Todoist::Config.enabled? && case_record.todoist_task_id.present?
      end
    end
  end
end
