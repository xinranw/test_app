class Query < ActiveRecord::Base
	# attr_accessible :title, :body
  def self.tracking_data(source, time_format, start_date, end_date)
    case source
      when "total_rev"
      when "bookings_rev" 
        then table_name = "bookings"  
      when "loot_rev"
      when "bookings"
        then table_name = "bookings"
      when "loot"  
    end

    case time_format
      when "hour"
        booked_at = "TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(booked_at) DIV 3600) * 3600 ))"
        group_by = "date(booked_at), hour(booked_at)"
      when "day"
        booked_at = "date(booked_at)"
        group_by = "date(booked_at)"
      when "month"
        booked_at = "CONCAT(year(booked_at), '-', monthname(booked_at))"
        group_by = "year(booked_at), month(booked_at)"
      when "year"
        booked_at = "year(booked_at)"
        group_by = "year(booked_at)"
    end

    @sql = "
      SELECT 
        #{booked_at} as counttime, count(id) as countnum
      FROM 
        #{table_name}
      WHERE 
        date(booked_at) >= '#{start_date}' && date(booked_at) <= '#{end_date}'
      GROUP BY
        #{group_by}
      "
    return connection.select_all(@sql).first(100)
  end


  def self.get_time_series(from, to, period, type_of_data)
  end

  # Last resort or maybe all other methods end up calling this method?
  # ==Parameters:
  # sql::
  #   User specified sql statement
  # type_of_data::
  #   One of the following :proportional_chart, :line
  def self.get_data_advanced(sql, type_of_data) 
  end

	def self.get_data1

  	@alldata = connection.select_all(
        "SELECT TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 )) as ctime, count(id) as countnum
        FROM bookings
        WHERE year(created_at) >= 2013
        GROUP BY TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 ) )")
  	return @alldata

	end

  def self.get_data2(time_param)
    @alldata2 = connection.select_all(
        "SELECT TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 )) as ctime, count(id) as countnum
        FROM bookings
        WHERE year(created_at) >= 2013
        GROUP BY TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 ) )")
    return @alldata2
  end

  def self.get_data3(select_clause, from_clause, where_clause, group_by_clause)
    sql = "
      SELECT 
        #{select_clause}
      FROM 
        bookings
      WHERE 
        year(created_at) >= 2013
      GROUP BY 
        TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 ) )
      "

    @alldata2 = connection.select_all("
      SELECT 
        TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 )) as ctime
        , count(id) as countnum
      FROM 
        bookings
      WHERE 
        year(created_at) >= 2013
      GROUP BY 
        TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 ) )
      ")
    return @alldata2
  end

end
