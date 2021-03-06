require '../modules/BuyOrderModule'
require '../modules/RentOrderModule'
require 'date'

class Transaction
    attr_accessor :movie, :type, :total, :date
        def initialize(movie, type)
            @movie=movie
            @type=type
            @total=0
            @date=Date.today
        end
        include BuyOrder
        include RentOrder
end
