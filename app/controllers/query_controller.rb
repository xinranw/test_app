class QueryController < ApplicationController
  include QuerydataHelper

  def fetch

    # Data for range1
    params_1 = {
      :constants => params[:constants],
      :data => params[:range1]
    }
    params_1[:data][:heatmap_source] = "clients"
    query = Query.get(params_1)
    if params_1[:constants][:ser_value] == "heatmap"
      @results = [query.execute_heatmap_query]
    else
      case (params[:constants][:sort])
        when "by_time", "by_time_cum"
          @results = [query.execute_time_query]
        else 
          @results = [query.execute_category_query]
      end
    end

    # Data for range2
    if (params[:constants][:comp] == 'true' || params[:constants][:ser_value] == 'heatmap')
      params_2 = {
        :constants => params[:constants],
        :data => params[:range2]
      }
      params_2[:data][:heatmap_source] = "providers"
      query_2 = Query.get(params_2)
      if params_1[:constants][:ser_value] == "heatmap"
        params_2[:data] = params[:range1]
        @results = @results.append(query_2.execute_heatmap_query)
      else
        case (params[:constants][:sort])
          when "by_time", "by_time_cum"
            @results = @results.append(query_2.execute_time_query)
          else 
            @results = @results.append(query_2.execute_category_query)
        end
      end
    end

    if params[:constants][:sort] == "by_time_cum"
      @results = cumulate(@results)
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
