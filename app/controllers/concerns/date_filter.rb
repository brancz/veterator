module DateFilter
  def set_filter_dates
    @from = Date.today
    @to = Date.tomorrow
    @from = Date.parse(params[:from]) unless params[:from].nil?
    @to = Date.parse(params[:to]) unless params[:from].nil?
  end

  def set_granularity
    @granularity = Record.granularities[Granularity.select_by_time_range(@from, @to)]
  end
end

