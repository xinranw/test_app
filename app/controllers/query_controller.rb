class QueryController < ApplicationController
  def index
    case (params[:sort])
      when "by_time"
        @results = [Query.time_data(params[:ser_type], params[:ser_value], params[:city], params[:time_format], params[:start_date], params[:end_date])]
        if (params[:comp] == "true")
          @results = @results.append(Query.time_data(params[:ser_type], params[:ser_value], params[:city], params[:time_format], params[:start_date2], params[:end_date2]))
        end
      when "by_cats", "by_location"
        @results = [Query.categorical_data(params[:ser_type], params[:ser_value], params[:city], params[:time_format], params[:start_date], params[:end_date], params[:sort], params[:res_num])]
        if (params[:comp] == "true")
          @results = @results.append(Query.categorical_data(params[:ser_type], params[:ser_value], params[:city], params[:time_format], params[:start_date2], params[:end_date2], params[:sort], params[:res_num]))
        end
    end

    # if request.xhr?
    #   render :json => @results
    # else
    #   render :csv => @results
    # end

    respond_to do |format|
      format.html {}
      format.json { render :json => @results }
      format.csv { render :csv => @results }
    end
  end

  def index_csv
    puts "here"
  end

end
