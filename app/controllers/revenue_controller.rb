class RevenueController < ApplicationController
	def index
		results = Query.get_data
	end
end
