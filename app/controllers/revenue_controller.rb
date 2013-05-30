class RevenueController < ApplicationController
	def index
		Query.getRevenueData
	end
end
