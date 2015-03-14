module DateFilter
  def set_filter_dates
    @from = Date.today
    @to = Date.today
    @from = Date.parse(params[:from]) unless params[:from].nil?
    @to = Date.parse(params[:to]) unless params[:from].nil?
  end
end

