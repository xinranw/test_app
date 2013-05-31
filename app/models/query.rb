class Query < ActiveRecord::Base
	# attr_accessible :title, :body
	def self.get_data
		result = connection.select_all("SELECT * FROM bookings")
		@rows = result.collect{|h| h['id']}
	end
end
