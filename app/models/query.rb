class Query < ActiveRecord::Base
	# attr_accessible :title, :body
  def self.tracking_data(source, time_format, start_date, end_date)

    case source
      when "bookings_rev"
        y = "sum(price)/1000"  
        type = "BookingInvoiceItem"
      when "loots_rev"
        y = "sum(price * commission_rate / 100) / 1000"
        type = "LootServiceInvoiceItem"
      when "bookings"
        y = "count(price)"
        type = "BookingInvoiceItem"
      when "loots"  
        y = "count(price)"
        type = "LootServiceInvoiceItem"
    end

    case time_format
      when "hour"
        created_at = "TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 ))"
        group_by = "hour(created_at)"
      when "day"
        created_at = "date(created_at)"
        group_by = "date(created_at)"
      when "month"
        created_at = "CONCAT(year(created_at), '-', monthname(created_at))"
        group_by = "year(created_at), month(created_at)"
      when "year"
        created_at = "year(created_at)"
        group_by = "year(created_at)"
    end

    table_name = "invoice_items"

    @sql = "
      SELECT 
        #{created_at} as x, #{y} as y
      FROM 
        #{table_name}
      WHERE 
        date(created_at) >= '#{start_date}' && date(created_at) <= '#{end_date}' && type = '#{type}'
      GROUP BY
        #{group_by}
      "
    return connection.select_all(@sql).first(100)
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
end
