class LootQuery < Query

  @@params
  @@sql = ""

  def initialize(params)
    if (params.has_key?(:ser_type) && params.has_key?(:ser_value) && params.has_key?(:city) && params.has_key?(:time_format) && params.has_key?(:sort) && params.has_key?(:res_num) && params.has_key?(:comp) && params.has_key?(:ser_value) && params.has_key?(:start_date) && params.has_key?(:end_date))
      @@params = params
      @@params[:end_date] = Date.parse(@@params[:end_date]) + 1
    else 
      raise ArgumentError.new "missing parameters"
    end
  end

  protected
  # Builds a sql query from @@params to obtain time-based data
  def get_time_query
    case @@params[:time_format]
      when "hour"
        group_by = "hour(ii.created_at)"
        order_by = "hour(ii.created_at)"
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
        y = "round(sum(ii.price * ii.commission_rate / 100) / 1000, 2)"
        as_y = "PROFIT"
      when "num"
        y = "count(ii.price)"
        as_y = "NUMBER_OF"
    end
    
    x = "ii.created_at"
    as_x = "#{@@params[:time_format]}".upcase
    service_type = "&& (ii.type = 'LootServiceInvoiceItem')"
    join_statements = "
      LEFT JOIN loot_services ls ON ls.id = ii.item_id
      LEFT JOIN loots l ON l.id = ls.loot_id
      LEFT JOIN lb_city_enums lbce ON l.lb_city_id = lbce.id
    "

    table_name = "invoice_items as ii"
    created_at = "ii.created_at"
    start_date = @@params[:start_date]
    end_date = @@params[:end_date]
    city = ((@@params[:city] == "") ? "" : "&& lbce.name = '#{@@params[:city]}'")

    @@sql = "
      SELECT 
        #{x} as #{as_x}, #{y} as #{as_y}
      FROM 
        #{table_name}
      #{join_statements}
      WHERE 
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') #{service_type} #{city}
      GROUP BY
        #{group_by}
    "
    return @@sql
  end
  # Builds a sql query from @@params to obtain category data
  def get_category_query
    join_statements = "
      JOIN lb_city_enums as lbce
        ON sp.lb_city_enum_id = lbce.id
      JOIN loots as l 
        ON sp.id = l.service_provider_id
      JOIN loot_services as ls
        ON l.id = ls.loot_id
      JOIN invoice_items as ii
        ON ls.id = ii.item_id
    "

    case @@params[:sort]
      when "by_cats"
        x = "sc.display_name"
        as_x = "SERVICE_CATEGORIES"
        group_by = "sc.display_name"
        join_statements += "
          JOIN service_categories as sc
            ON ls.service_category_id = sc.id"
      when "by_prov"
        x = "ls.name"
        as_x = "LOOT"
        group_by = "ls.name"
      when "by_location"
        if (@@params[:city] == "")
          x = "lbce.long_name"
          as_x = "CITIES"
          group_by = "lbce.long_name"
        else 
          x = "z.name"
          as_x = "ZONES"
          group_by = "z.name"
          join_statements +="
            JOIN zones as z
              ON sp.zone_id = z.id"
        end
    end
    case @@params[:ser_value]
      when "rev"
        as_y = "PROFIT"
        if @@params[:sort] == "by_prov"
          y = "round(sum(ii.price * ii.commission_rate / 100) / 1000, 2) as #{as_y},
               sp.name as PROVIDER,
               count(sp.name) as SOLD"
        else 
          y = "round(sum(ii.price * ii.commission_rate / 100) / 1000, 2) as #{as_y}"
        end
      when "num"
        as_y = "NUMBER_OF"
        if @@params[:sort] == "by_cats"
          y = "count(sc.display_name) as #{as_y}"
        elsif @@params[:sort] == "by_prov"
          y = "count(ls.name) as #{as_y},
               sp.name as PROVIDER,
               round(sum(ii.price * ii.commission_rate / 100), 0) as PROFIT"
        elsif@@params[:sort] == "by_location"
          if (@@params[:city] == "")
            y = "count(lbce.long_name)"
          else
            y = "count(z.name)"
          end
        end
    end

    table_name = "service_providers as sp"
    created_at = "ii.created_at"
    loots_where = "&& (ii.type = 'LootServiceInvoiceItem')"
    start_date = @@params[:start_date]
    end_date = @@params[:end_date]
    city = ((@@params[:city] == "") ? "" : "&& (lbce.name = '#{@@params[:city]}')")
    limit = "LIMIT #{@@params[:res_num]}"

    @@sql = "
      SELECT 
        #{x} as #{as_x}, #{y}
      FROM 
        #{table_name}
      #{join_statements}
      WHERE 
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') #{loots_where} #{city}
      GROUP BY
        #{group_by}
      ORDER BY 
        #{as_y} DESC
      #{limit}
    "
    return @@sql
  end

  # Builds a sql query from @@params to obtain heatmap data based on client or provider addresses
  def get_heatmap_query
    x = "gc.latitude"
    y = "gc.longitude"
    count = "count(a.id)"
    table_name = "invoice_items ii"
    join_statements = "
      JOIN invoices i
        ON i.id = ii.invoice_id
        AND i.billable_type = 'client'
        AND ii.type = 'LootServiceInvoiceItem'
      JOIN clients c
        ON c.id = billable_id
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
    created_at = "ii.created_at"
    start_date = @@params[:start_date]
    end_date = @@params[:end_date]
    city = ((@@params[:city] == "") ? "" : "&& lbce.name = '#{@@params[:city]}'")
    group_statement = "GROUP BY a.id"

    sql = "
      SELECT 
        #{x} as Latitude, #{y} as Longitude, #{count} as Count
      FROM 
        #{table_name}
      #{join_statements}
      WHERE 
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') #{city}
      #{group_statement}
      ORDER BY Count DESC
    "
  end

  # def get_heatmap_query
  #   x = "gc.latitude"
  #   y = "gc.longitude"
  #   count = "count(z.name)"
  #   table_name = "invoice_items ii"
  #   join_statements = "
  #   JOIN invoices i
  #     ON i.id = ii.invoice_id
  #     AND i.billable_type = 'client'
  #     AND ii.type = 'LootServiceInvoiceItem'
  #   JOIN clients c
  #     ON c.id = billable_id
  #   JOIN addresses a
  #     ON c.address_id = a.id
  #   JOIN zones z
  #     ON z.id = a.zone_id
  #   JOIN addresses z_a
  #     ON z_a.id = z.address_id
  #   JOIN geocodings g
  #     ON z.id = g.geocodable_id
  #     AND g.geocodable_type = 'Zone'
  #   JOIN geocodes gc
  #     ON g.geocode_id = gc.id
  #   JOIN lb_city_enums lbce
  #     ON lbce.id = c.lb_city_enum_id
  #   "
  #   created_at = "ii.created_at"
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