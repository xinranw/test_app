class Query < ActiveRecord::Base

  public 

  # @param [String] bookings|loots|signups 
  # @return [Query] that will generate the appropriate
  #   SQL.  Otherwise it will raise an exception if passed an invalid
  #   type.
  def self.get(parameters)
    params = {
      :ser_value => parameters[:constants][:ser_value],
      :time_format => parameters[:constants][:time_format],
      :sort => parameters[:constants][:sort],
      :res_num => parameters[:constants][:res_num],
      :comp => parameters[:constants][:comp],
      :ser_type => parameters[:data][:ser_type],
      :city => parameters[:data][:city],
      :start_date => parameters[:data][:start_date],
      :end_date => parameters[:data][:end_date],
      :heatmap_source => parameters[:data][:heatmap_source]
    }

    case params[:ser_type]
      when "bookings"
        return BookingQuery.new(params)
      when "loots" 
        return LootQuery.new(params)
      when "signups"
        return SignupQuery.new(params)
      else raise StandardError.new("Invalid service type:" + params[:ser_type] + " passed to Query.get")
    end
  end

  # Performs a sql query for time-based data
  # @return [json] the results of the time-based sql query
  def execute_time_query
    sql = get_time_query
    return connection.select_all(sql)
  end
  # Performs a sql query for categorical data
  # @return [json] the results of the categorical sql query
  def execute_category_query
    sql = get_category_query
    return connection.select_all(sql)
  end
  # Performs a sql query for heatmap data
  # @return [json] the results of the heatmap sql Query
  def execute_heatmap_query
    sql = get_heatmap_query
    return connection.select_all(sql)
  end
  protected

  # @return [String] sql that returns [[category, value], ...]
  def get_category_query
    raise NotImplementatedError("This is an abstract class (not really since this is Ruby...)")
  end

  # @return [String] sql that returns [[time, value], ...]
  def get_time_query
    raise NotImplementatedError("This is an abstract class (not really since this is Ruby...)")
  end

end