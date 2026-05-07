module Todoist
  class Backfill
    Result = Struct.new(:created, :failed, :skipped, keyword_init: true)

    def initialize(dry_run: true, limit: nil)
      @dry_run = dry_run
      @limit = limit&.to_i
      @result = Result.new(created: 0, failed: 0, skipped: 0)
    end

    def run
      scope = Case.todoist_unsynced.order(:created_at)
      scope = scope.limit(@limit) if @limit.present? && @limit.positive?

      scope.find_each do |case_record|
        if @dry_run
          @result.skipped += 1
          next
        end

        before = case_record.todoist_task_id
        Todoist::CaseSync.sync_create(case_record)
        case_record.reload

        if before.blank? && case_record.todoist_task_id.present?
          @result.created += 1
        else
          @result.failed += 1
        end
      end

      @result
    end
  end
end
