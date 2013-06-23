require 'td-client'

module LogSummaryHelper
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module Scope
    TOTALLY = 0
    DAILY   = 1
    MONTHLY = 2
    YEARLY  = 3
  end

  module Status
    PROCESSING = 0
    SUCCESSED  = 1
    FAILED     = 2
  end

  module Client
    WEB     = 0
    IOS     = 1
    ANDROID = 2
    PC      = 3
  end

  LOG_DB_NAME = 'rails_production'



  module ClassMethods
    def create_summary_job(date, scope)
      date_str = date.strftime("%Y-%m-%d JST")
      period = get_period_from_scope(scope)
      job = client.query(
        LOG_DB_NAME,
        "SELECT COUNT (*)
        FROM login
        WHERE
        TD_TIME_RANGE(
          time,
          '#{date_str}',
          TD_TIME_ADD('#{date_str}', '#{period}')
        )"
      )
    end

    def wait_job_finished(job)
      until job.finished? || job.status == "error"
        sleep 2
        job.update_status!
      end
    end

    def find_target_record(params)
      where(params).first
    end

  private

    def client
      TreasureData::Client.new(ENV['TREASURE_DATA_API_KEY'])
    end

    def get_period_from_scope(scope)
      case scope
      when :daily then '1d'
      else
        '1d'
      end
    end
  end
end
