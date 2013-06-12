class Query < ActiveRecord::Base
	# attr_accessible :title, :body
  def self.time_data(ser_type, ser_value, city, time_format, start_date, end_date)
    if ser_type == "bookings"
      service_type = "BookingInvoiceItem"
      join_statement = "
      LEFT JOIN bookings as b ON ii.item_id = b.id 
      LEFT JOIN service_provider_services as sps ON b.service_provider_service_id = sps.id
      LEFT JOIN service_providers as sp ON sps.service_provider_id = sp.id
      LEFT JOIN lb_city_enums as lbce ON sp.lb_city_enum_id = lbce.id
      "
    else ser_type == "loots"
      service_type = "LootServiceInvoiceItem"
      join_statement = "
      LEFT JOIN loot_services ls ON ls.id = ii.item_id
      LEFT JOIN loots l ON l.id = ls.loot_id
      LEFT JOIN lb_city_enums lbce ON l.lb_city_id = lbce.id
      "
    end

    # Set the x value and group_by
    case time_format
      when "hour"
        x = "TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(ii.created_at) DIV 3600) * 3600 ))"
        group_by = "hour(ii.created_at)"
      when "day"
        x = "date(ii.created_at)"
        group_by = "date(ii.created_at)"
      when "month"
        x = "CONCAT(year(ii.created_at), '-', monthname(ii.created_at))"
        group_by = "year(ii.created_at), month(ii.created_at)"
      when "year"
        x = "year(ii.created_at)"
        group_by = "year(ii.created_at)"
    end

    # Set the y value
    if ser_value == "rev"
      if ser_type == "bookings"
        y = "round(sum(ii.price)/1000, 2)"
      else ser_type == "loots"
        y = "round(sum(ii.price * ii.commission_rate / 100) / 1000, 2)"
      end
    else ser_value == "num"
      y = "count(ii.price)"
    end

    table_name = "invoice_items as ii"
    created_at = "ii.created_at"

    city = ((city == "") ? "" : "&& lbce.name = '#{city}'")

    @sql = "
      SELECT 
        #{x} as x, #{y} as y
      FROM 
        #{table_name}
      #{join_statement}
      WHERE 
        #{created_at} >= '#{start_date}' && #{created_at} <= '#{end_date}' && type = '#{service_type}' #{city}
      GROUP BY
        #{group_by}
      "
    return connection.select_all(@sql)
  end

  def self.categorical_data(ser_type, ser_value, city, time_format, start_date, end_date, sort, res_num)
    join_statements = 
      "JOIN lb_city_enums as lbce
        ON sp.lb_city_enum_id = lbce.id"
    loots_where = ""
    if ser_type == "bookings"
      created_at = "b.created_at"
      join_statements += "
        JOIN service_provider_services as sps
          ON sp.id = sps.service_provider_id
        JOIN bookings as b 
          ON sps.id = b.service_provider_service_id
        "
    else ser_type == "loots"
      created_at = "ii.created_at"
      loots_where = "&& (ii.type = 'LootServiceInvoiceItem')"
      join_statements += "
        JOIN loots as l 
          ON sp.id = l.service_provider_id
        JOIN loot_services as ls
          ON l.id = ls.loot_id
        JOIN invoice_items as ii
          ON ls.id = ii.item_id
        "
    end
    if sort == "by_cats"
      x = "sc.display_name"
      group_by = "sc.display_name"
      if ser_type == "bookings"
        join_statements += "
          JOIN service_categories as sc
            ON sps.service_category_id = sc.id"
      else ser_type == "loots"
        join_statements += "
          JOIN service_categories as sc
            ON ls.service_category_id = sc.id"
      end
    else sort == "by_location"
      x = "z.name"
      group_by = "z.name"
      join_statements +="
        JOIN zones as z
          ON sp.zone_id = z.id"
    end

    #set the y value
    if ser_value == "rev"
      if ser_type == "bookings"
        y = "round(sum(b.price) / 1000, 0)"
      else ser_type == "loots"
        y = "round(sum(ii.price * ii.commission_rate / 100) / 1000, 0)"
      end
    else ser_value == "num"
      if sort == "by_cats"
        y = "count(sc.display_name)"
      else sort == "by_location"
        y = "count(z.name)"
      end
    end


    table_name = "service_providers as sp"
    city = ((city == "") ? "" : "&& (lbce.name = '#{city}')")
    

    @sql = "
      SELECT 
        #{x} as x, #{y} as y
      FROM 
        #{table_name}
      #{join_statements}
      WHERE 
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') #{loots_where} #{city}
      GROUP BY
        #{group_by}
      ORDER BY 
        y DESC
      LIMIT 
        #{res_num}
      "
      return connection.select_all(@sql)
  end

  end
