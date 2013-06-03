class Query < ActiveRecord::Base
	# attr_accessible :title, :body
	def self.get_data
	@alldata = connection.select_all(
      "SELECT TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 )) as ctime, count(id) as countnum
      FROM bookings
      WHERE year(created_at) >= 2013
      GROUP BY TIME(FROM_UNIXTIME((UNIX_TIMESTAMP(created_at) DIV 3600) * 3600 ) )")
	return @alldata
	end
end
