class SignupQuery < Query
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
        x = "TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(c.created_at) DIV 3600) * 3600 ))"
        group_by = "hour(c.created_at)"
      when "day"
        x = "date(c.created_at)"
        group_by = "date(c.created_at)"
      when "month"
        x = "CONCAT(year(c.created_at), '-', monthname(c.created_at))"
        group_by = "year(c.created_at), month(c.created_at)"
      when "year"
        x = "year(c.created_at)"
        group_by = "year(c.created_at)"
    end

    case @@params[:ser_value]
      when "num"
        y = "count(c.created_at)"
    end

    join_statements = "
    JOIN lb_city_enums as lbce 
      ON lbce.id = c.lb_city_enum_id
    "

    table_name = "clients as c"
    created_at = "c.created_at"
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
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') && (aasm_state <> 'never_purchased' ) #{city}
      GROUP BY
        #{group_by}
    "
    return @@sql
  end

  def get_category_data
    raise StandardError.new"Signups cannot be categorical"
  end

  def get_heatmap_query
    x = "gc.latitude"
    y = "gc.longitude"
    count = "count(z.name)"
    table_name = "clients c"
    join_statements = "
      JOIN addresses a
        ON c.address_id = a.id
      JOIN zones z
        ON z.id = a.zone_id
      JOIN addresses z_a
        ON z_a.id = z.address_id
      JOIN geocodings g
        ON z.id = g.geocodable_id
        AND g.geocodable_type = 'Zone'
      JOIN geocodes gc
        ON g.geocode_id = gc.id
      JOIN lb_city_enums lbce
        ON lbce.id = c.lb_city_enum_id
    "
    created_at = "c.created_at"
    start_date = @@params[:start_date]
    end_date = @@params[:end_date]
    city = ((@@params[:city] == "") ? "" : "&& lbce.name = '#{@@params[:city]}'")
    group_statement = "GROUP BY z.name"
    sql = "
      SELECT 
        #{x} as x, #{y} as y, #{count} as count
      FROM 
        #{table_name}
      #{join_statements}
      WHERE 
        (#{created_at} >= '#{start_date}') && (#{created_at} <= '#{end_date}') && (aasm_state <> 'never_purchased' ) #{city}
      #{group_statement}
    "
  end
end