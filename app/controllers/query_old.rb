# class Query<ActiveRecord::Base
#   def show
#     @connection = ActiveRecord::Base.establish_connection(
#                   :adapter => "mysql2",
#                   :host => "localhost",
#                   :database => "lb_production",
#                   :username => "root",
#                   :password => ""
#     )

#     sql = "SELECT * FROM bookings"
#     @result = @connection.connection.execute(sql);
#     @data = @result
#   end
# end