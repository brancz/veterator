module DateFilter
  def set_filter_dates
    @from = Date.today
    @to = Date.tomorrow
    @from = Date.parse(params[:from]) unless params[:from].nil?
    @to = Date.parse(params[:to]) unless params[:from].nil?
  end

  def granularity
    # these calculartions are not very exact but are good enough to select a granularity
    time_in_seconds = (@to - @from)
    granularity = :finest
    # keys are from the granularity enum in Record model
    time = {
      daily: time_in_seconds / (3600 * 24),
      monthly: time_in_days / 30,
      yearly: time_in_months / 12
    }
    time.each do |key, value|
      granularity = key unless value < 1.0
    end
    granularity
  end
end

