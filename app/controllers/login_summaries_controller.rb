class LoginSummariesController < ApplicationController
  def index
    summaries = LoginSummary.all
    @end_at = summaries.last.date
    @start_at = @end_at - summaries.count
    @categories = summaries.map{|summary| summary.date.strftime('%Y/%m/%d')}
    @data = summaries.map(&:count)

    @h = LazyHighCharts::HighChart.new("graph") do |f|
      f.chart(type: "column")
      f.title(text: "Login Summary")
      f.xAxis(categories: @categories)
      f.series(name: "Login Count", data: @data)
    end
  end
end
