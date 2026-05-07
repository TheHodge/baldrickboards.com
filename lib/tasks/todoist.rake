namespace :todoist do
  desc "Backfill existing triage cases into Todoist. Usage: rake todoist:backfill DRY_RUN=true LIMIT=100"
  task backfill: :environment do
    dry_run = ENV.fetch("DRY_RUN", "true") == "true"
    limit = ENV["LIMIT"]

    result = Todoist::Backfill.new(dry_run: dry_run, limit: limit).run

    puts "Todoist backfill complete"
    puts "dry_run: #{dry_run}"
    puts "created: #{result.created}"
    puts "failed: #{result.failed}"
    puts "skipped: #{result.skipped}"
  end
end
