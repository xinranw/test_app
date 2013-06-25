class SignupQuery < Query
  @@params
  @@sql = ""

  # Initializes an instance of SignupQuery class. Sets @@params to the parameters passed in
  # @param params [hash] the parameters passed in from query_controller
  def initialize(params)
    if (params.has_key?("ser_type") && params.has_key?("ser_value") && params.has_key?("city") && params.has_key?("time_format") && params.has_key?("sort") && params.has_key?("res_num") && params.has_key?("comp") && params.has_key?("ser_value") && params.has_key?("start_date") && params.has_key?("end_date"))
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
      when "num"
        y = "count(c.created_at)"
    end

    join_statements = "
    JOIN lb_city_enums as lbce 
      ON lbce.id = c.lb_city_enum_id
    "
    x = "ii.created_at"
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

  # Builds a sql query from @@params to obtain heatmap data based on client or provider addresses
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