class LoginSummary < ActiveRecord::Base
  include LogSummaryHelper
  default_scope order('date ASC')

  def count
    return 0 if status != Status::SUCCESSED
    super
  end
end
