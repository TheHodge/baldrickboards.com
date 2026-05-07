require "digest"

module Todoist
  class WebhookProcessor
    def self.process!(payload)
      new(payload).process!
    end

    def initialize(payload)
      @payload = payload.with_indifferent_access
    end

    def process!
      events.each do |event|
        handle_event(event.with_indifferent_access)
      end
    end

    private

    attr_reader :payload

    def events
      return payload[:events] if payload[:events].is_a?(Array)
      [payload]
    end

    def handle_event(event)
      event_key = derive_event_key(event)
      return if TodoistWebhookEvent.exists?(event_key: event_key)

      ActiveRecord::Base.transaction do
        TodoistWebhookEvent.create!(
          event_key: event_key,
          event_name: event[:event_name] || event[:name],
          payload: event,
          processed_at: Time.current
        )

        apply_event(event)
      end
    end

    def apply_event(event)
      task_id = extract_task_id(event)
      return unless task_id.present?

      case_record = Case.find_by(todoist_task_id: task_id.to_s)
      return unless case_record

      if comment_event?(event)
        content = extract_comment_content(event)
        return if content.blank?
        return if outbound_sync_comment?(content)

        comment = case_record.case_comments.create!(
          content: content,
          admin_name: "Baldrick Team"
        )
        TriageMailer.admin_comment(case_record, comment).deliver_now
      elsif reopened_event?(event)
        case_record.update!(status: "open", todoist_last_event_at: Time.current)
      elsif completed_event?(event)
        case_record.update!(status: "closed", todoist_last_event_at: Time.current)
      elsif deleted_event?(event)
        case_record.destroy!
      end
    end

    def derive_event_key(event)
      event[:event_id].presence ||
        event[:id].presence ||
        Digest::SHA256.hexdigest(event.to_json)
    end

    def extract_task_id(event)
      event[:task_id].presence ||
        event.dig(:event_data, :task_id).presence ||
        event.dig(:event_data, :item_id).presence ||
        event.dig(:event_data, :item, :id).presence ||
        event.dig(:event_data, :id).presence ||
        event.dig(:task, :id).presence ||
        event[:id].presence
    end

    def extract_comment_content(event)
      event[:content].presence || event.dig(:event_data, :content).presence
    end

    def event_name(event)
      (event[:event_name] || event[:name] || "").to_s
    end

    def comment_event?(event)
      name = event_name(event)
      name.include?("comment") || name.include?("note:added")
    end

    def outbound_sync_comment?(content)
      content.start_with?("Admin comment from ", "User reply from ")
    end

    def completed_event?(event)
      event_name(event).include?("complete") || event_name(event).include?("close")
    end

    def reopened_event?(event)
      name = event_name(event)
      name.include?("reopen") || name.include?("uncomplete") || name.include?("uncompleted")
    end

    def deleted_event?(event)
      event_name(event).include?("delete")
    end
  end
end
