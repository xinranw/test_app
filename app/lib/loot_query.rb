class LootQuery < Query

  @@params
  @@sql = ""

  def initialize(params)
    if (params.has_key?("ser_type") && params.has_key?("ser_value") && params.has_key?("city") && params.has_key?("time_format") && params.has_key?("sort") && params.has_key?("res_num") && params.has_key?("comp") && params.has_key?("ser_value") && params.has_key?("start_date") && params.has_key?("end_date"))
      @@params = params
    else 
      raise ArgumentError.new "missing parameters"
    end
  end

  protected

  def get_time_query
    case @@params[:time_format]
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

    case @@params[:ser_value]
      when "rev"
        y = "round(sum(ii.price * ii.commission_rate / 100) / 1000, 2)"
      when "num"
        y = "count(ii.price)"
    end

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
        #{x} as x, #{y} as y
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
        group_by = "sc.display_name"
        join_statements += "
          JOIN service_categories as sc
            ON ls.service_category_id = sc.id"
      when "by_location"
        x = "z.name"
        group_by = "z.name"
        join_statements +="
          JOIN zones as z
            ON sp.zone_id = z.id"
    end
    case @@params[:ser_value]
      when "rev"
        y = "round(sum(ii.price * ii.commission_rate / 100) / 1000, 0)"
      when "num"
        if @@params[:sort] == "by_cats"
          y = "count(sc.display_name)"
        else @@params[:sort] == "by_location"
          y = "count(z.name)"
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
      #{limit}
    "
    return @@sql
  end
end