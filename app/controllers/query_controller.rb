class QueryController < ApplicationController
  def fetch
    if params[:comp] == 'true'
      params_2 = params
      params_2[:start_date] = params[:start_date2]
      params_2[:end_date] = params[:end_date2]
      query2 = Query.get(params[:ser_type], params_2)
    end
    query = Query.get(params[:ser_type], params)

    case (params[:sort])
      when "by_time"
        @results = [query.execute_time_query]
        if params[:comp] == 'true'
          @results = @results.append(query2.execute_time_query)
        end
      else 
        @results = [query.execute_category_query]
        if params[:comp] == 'true'
          @results = @results.append(query2.execute_category_query)
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
