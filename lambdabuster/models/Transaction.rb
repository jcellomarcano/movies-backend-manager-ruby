module 
class Transaction
    attr_accessor :movie, :type, :total, :date
        def initialize(movie, type)
            @movie=movie
            @type=type
            @total=0
            @date=Date.new(today)
        end
        include BuyOrder
        include RentOrder
end
