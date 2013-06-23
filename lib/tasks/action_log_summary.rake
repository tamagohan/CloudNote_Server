namespace :action_log_summary do
  desc 'daily_login_summary'
  task :daily_login_summary, 'date'
  task :daily_login_summary => :environment do |x, args|
    date = (args.date.nil? ? Time.zone.now.yesterday : Time.zone.parse(args.date)).beginning_of_day
    job = LoginSummary.create_summary_job(date, :daily)
    LoginSummary.wait_job_finished(job)


    result = job.success? ? LoginSummary::Status::SUCCESSED : LoginSummary::Status::FAILED
    count  = job.success? ? job.result.first.first : 0
    search_params = {date: date, scope: LoginSummary::Scope::DAILY}
    summary = LoginSummary.find_target_record(search_params)
    params  = search_params.merge(count: count, status: result, client_id: LoginSummary::Client::WEB)
    if summary.nil?
      LoginSummary.create!(params)
    else
      summary.update_attributes!(params)
    end
  end
end
