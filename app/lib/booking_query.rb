class BookingQuery < Query
  @@params
  @@sql = ""

  def initialize(params)
    if (params.has_key?("ser_type") && params.has_key?("ser_value") && params.has_key?("city") && params.has_key?("time_format") && params.has_key?("sort") && params.has_key?("res_num") && params.has_key?("comp") && params.has_key?("start_date") && params.has_key?("end_date"))
      @@params = params
    else 
      raise ArgumentError.new "missing parameters"
    end
  end

  protected

  def get_time_query
    case @@params[:time_format]
      when "hour"
        x = "TIME(CONVERT_TZ(FROM_UNIXTIME((UNIX_TIMESTAMP(ii.created_at) DIV 3600) * 3600 ),'UTC', 'US/Eastern'))"
        group_by = "x"
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

    case @@params[:ser_value]
      when "rev"
        y = "round(sum(ii.price), 0)"
      when "num"
        y = "count(ii.price)"
    end

    service_type = "&& type = 'BookingInvoiceItem'"
    join_statements = "
    JOIN bookings as b ON ii.item_id = b.id 
    JOIN service_provider_services as sps ON b.service_provider_service_id = sps.id
    JOIN service_providers as sp ON sps.service_provider_id = sp.id
    JOIN lb_city_enums as lbce ON sp.lb_city_enum_id = lbce.id
    "

    table_name = "invoice_items as ii"
    created_at = "ii.created_at"
    start_date = @@params[:start_date]
    end_date = @@params[:end_date]
    city = ((@@params[:city] == "") ? "" : "&& lbce.name = '#{@@params[:city]}'")

    @@sql = "
      SELECT 
        #{x} as x, #{y} as y
      FROM 
        #{table_name}
      #{join_statements}
      WHERE 
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') #{service_type} #{city}
      GROUP BY
        #{group_by}
      ORDER BY x
    "
    return @@sql
  end

  def get_category_query
    join_statements = "
      JOIN lb_city_enums as lbce
        ON sp.lb_city_enum_id = lbce.id
      JOIN service_provider_services as sps
        ON sp.id = sps.service_provider_id
      JOIN bookings as b 
        ON sps.id = b.service_provider_service_id
    "
    case @@params[:sort]
      when "by_cats"
        x = "sc.display_name"
        group_by = "sc.display_name"
        join_statements += "
          JOIN service_categories as sc
            ON sps.service_category_id = sc.id"
      when "by_location"
        x = "z.name"
        group_by = "z.name"
        join_statements +="
          JOIN zones as z
            ON sp.zone_id = z.id"
    end
    case @@params[:ser_value]
      when "rev"
        y = "round(sum(b.price) / 1000, 0)"
      when "num"
        if @@params[:sort] == "by_cats"
          y = "count(sc.display_name)"
        else @@params[:sort] == "by_location"
          y = "count(z.name)"
        end
    end
    table_name = "service_providers as sp"
    created_at = "b.created_at"
    start_date = @@params[:start_date]
    end_date = @@params[:end_date]
    city = ((@@params[:city] == "") ? "" : "&& (lbce.name = '#{@@params[:city]}')")
    limit = "LIMIT #{@@params[:res_num]}"

    @@sql = "
      SELECT 
        #{x} as x, #{y} as y
      FROM 
        #{table_name}
      #{join_statements}
      WHERE 
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') #{city}
      GROUP BY
        #{group_by}
      ORDER BY 
        y DESC
      #{limit}
    "
    return @@sql
  end

  ##### Get client addresses
  def get_heatmap_query
    x = "gc.latitude"
    y = "gc.longitude"
    count = "count(a.id)"
    table_name = "clients c"
    join_statements = "
      JOIN bookings b
        ON b.client_id = c.id
      JOIN addresses a
        ON c.address_id = a.id
      JOIN geocodings g
        ON a.id = g.geocodable_id
        AND g.geocodable_type = 'Address'
      JOIN geocodes gc
        ON g.geocode_id = gc.id
      JOIN lb_city_enums lbce
        ON lbce.id = c.lb_city_enum_id
    "
    created_at = "b.created_at"
    start_date = @@params[:start_date]
    end_date = @@params[:end_date]
    city = ((@@params[:city] == "") ? "" : "&& lbce.name = '#{@@params[:city]}'")
    group_statement = "GROUP BY a.id"

    sql = "
      SELECT 
        #{x} as x, #{y} as y, #{count} as count
      FROM 
        #{table_name}
      #{join_statements}
      WHERE 
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') #{city}
      #{group_statement}
      ORDER BY count DESC
    "
  end
  
  # def get_heatmap_query
  #   x = "gc.latitude"
  #   y = "gc.longitude"
  #   count = "count(z.name)"
  #   table_name = "clients c"
  #   join_statements = "
  #     JOIN bookings b
  #       ON b.client_id = c.id
  #     JOIN addresses a
  #       ON c.address_id = a.id
  #     JOIN zones z 
  #       ON z.id = a.zone_id
  #     JOIN addresses z_a 
  #       ON z_a.id = z.address_id
  #     JOIN geocodings g
  #       ON z.id = g.geocodable_id
  #       AND g.geocodable_type = 'Zone'
  #     JOIN geocodes gc
  #       ON g.geocode_id = gc.id
  #     JOIN lb_city_enums lbce
  #       ON lbce.id = c.lb_city_enum_id
  #   "
  #   created_at = "b.created_at"
  #   start_date = @@params[:start_date]
  #   end_date = @@params[:end_date]
  #   city = ((@@params[:city] == "") ? "" : "&& lbce.name = '#{@@params[:city]}'")
  #   group_statement = "GROUP BY z.name"
  #   sql = "
  #     SELECT 
  #       #{x} as x, #{y} as y, #{count} as count
  #     FROM 
  #       #{table_name}
  #     #{join_statements}
  #     WHERE 
  #       (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') #{city}
  #     #{group_statement}
  #   "
  # end

end