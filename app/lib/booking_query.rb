class BookingQuery < Query
  @@params
  @@sql = ""

  def initialize(params)
    if (params.has_key?(:ser_type) && params.has_key?(:ser_value) && params.has_key?(:city) && params.has_key?(:time_format) && params.has_key?(:sort) && params.has_key?(:res_num) && params.has_key?(:comp) && params.has_key?(:start_date) && params.has_key?(:end_date))
      @@params = params
    else 
      raise ArgumentError.new "missing parameters"
    end
  end

  protected
  # Builds a sql query from @@params to obtain time-based data
  def get_time_query
    case @@params[:time_format]
      when "hour"
        group_by = "hour(x)"
        order_by = "hour(x)"
      when "day"
        group_by = "date(ii.created_at)"
        order_by = "date(ii.created_at)"
      when "month"
        group_by = "year(ii.created_at), month(ii.created_at)"
        order_by = "ii.created_at"
      when "year"
        group_by = "year(ii.created_at)"
        order_by = "year(ii.created_at)"
    end

    case @@params[:ser_value]
      when "rev"
        y = "round(sum(ii.price) / 1000, 0)"
      when "num"
        y = "count(ii.price)"
    end
    x = "ii.created_at"
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
      ORDER BY 
        #{order_by}
    "
    return @@sql
  end
  # Builds a sql query from @@params to obtain category data
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
      when "by_prov"
        x = "sp.name"
        group_by = "sp.name"
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
        elsif @@params[:sort] == "by_prov"
          y = "count(sp.name)"
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

  # Builds a sql query from @@params to obtain heatmap data based on client or provider addresses
  def get_heatmap_query
    x = "gc.latitude"
    y = "gc.longitude"
    count = "count(a.id)"
    if @@params[:heatmap_source] == "clients"
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
    else @@params[:heatmap_source] == "providers"
      table_name = "service_providers sp"
      join_statements = "
        JOIN service_provider_services sps
          ON sps.service_provider_id = sp.id
        JOIN bookings b
          ON b.service_provider_service_id = sps.id
        JOIN addresses a 
          ON a.id = sp.company_address_id
        JOIN geocodings g
          ON a.id = g.geocodable_id
          AND g.geocodable_type = 'Address'
        JOIN geocodes gc
          ON g.geocode_id = gc.id
        JOIN lb_city_enums lbce
          ON lbce.id = sp.lb_city_enum_id
      "
    end
    start_date = @@params[:start_date]
    end_date = @@params[:end_date]
    created_at = "b.created_at"
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