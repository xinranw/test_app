class QueryController < ApplicationController
  def fetch
    puts params[:source]
    puts params[:time_format]
    puts params[:start_date]
    puts params[:end_date]
    @results2 = Query.tracking_data(
      params[:source], 
      params[:time_format], 
      params[:start_date],
      params[:end_date])
    if request.xhr?
      render :json => @results2
    end
    return @results2
  end

	def index
		@results = Query.get_data1
	end
end
