namespace :action_log_summary do
  desc 'daily_login_summary'
  task :daily_login_summary, 'date'
  task :daily_login_summary => :environment do |x, args|
    client = TreasureData::Client.new(ENV['TREASURE_DATA_API_KEY'])
    date = args.date || Time.zone.now.strftime("%Y-%m-%d JST")
    job = client.query(
      'rails_production',
        "SELECT COUNT (*)
        FROM login
        WHERE TD_TIME_RANGE(time, '#{date}', TD_TIME_ADD('#{date}', '1d'))"
    )
    until job.finished? || job.status == "error"
      sleep 2
      job.update_status!
    end
    if job.success?
      p job.result
    end
  end
end
