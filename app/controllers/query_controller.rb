class QueryController < ApplicationController
  def fetch
    puts params[:source]
    puts params[:time_format]
    puts params[:start_date]
    puts params[:end_date]
    puts params[:comp]
    puts params[:start_date2]
    puts params[:end_date2]

    @results = [Query.tracking_data(
      params[:source], 
      params[:time_format], 
      params[:start_date],
      params[:end_date]
    )]
    
    if (params[:comp] == "true")
      @results = @results.append(Query.tracking_data(
        params[:source], 
        params[:time_format], 
        params[:start_date2],
        params[:end_date2]))
    end

    if request.xhr?
      render :json => @results
    end
    return @results
  end

	def index
		@results = Query.get_data1
	end
end
