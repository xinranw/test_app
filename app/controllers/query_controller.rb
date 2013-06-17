class QueryController < ApplicationController
  def fetch
    query = Query.get(params[:ser_value], params[:ser_type], params)
    if (params[:comp] == 'true' && params[:ser_value] != 'heatmap')
      params_2 = params
      params_2[:ser_type] = params[:ser_type2]
      params_2[:city] = params[:city2]
      params_2[:start_date] = params[:start_date2]
      params_2[:end_date] = params[:end_date2]
      query_2 = Query.get(params[:ser_type], params_2)
    end

    if params[:ser_value] == "heatmap"
      @results = [query.execute_heatmap_query]
    else
      case (params[:sort])
        when "by_time"
          @results = [query.execute_time_query]
          if params[:comp] == 'true'
            @results = @results.append(query_2.execute_time_query)
          end
        else 
          @results = [query.execute_category_query]
          if params[:comp] == 'true'
            @results = @results.append(query_2.execute_category_query)
          end
      end
    end

    # if request.xhr?
    #   render :json => @results
    # else
    #   render :csv => @results
    # end
    respond_to do |format|
      format.html 
      format.json { render :json => @results }
      format.csv { render :csv => @results }
    end 
  end

end
