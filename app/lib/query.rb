class Query < ActiveRecord::Base

  public 

  # @param [String] bookings|loots|signups 
  # @return [Query] that will generate the appropriate
  #   SQL.  Otherwise it will raise an exception if passed an invalid
  #   type.
  def self.get(ser_type, params)
    case ser_type
      when "bookings"
        BookingQuery.new(params)
      when "loots" 
        LootQuery.new(params)
      when nil
      else raise StandardError.new "Invalid data type #{ser_type} passed to Query.get"
    end
  end

  def execute_time_query
    sql = get_time_query
    return connection.select_all(sql)
  end

  def execute_category_query
    sql = get_category_query
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