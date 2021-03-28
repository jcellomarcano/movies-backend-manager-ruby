class Movie
    attr_accessor :name, :runtime, :categories,
                    :release_date, :directors, :actors,
                    :price, :rent_price, :premiere, :discount

    def initialize(name, runtime, categories,
        release_date, directors, actors,
        price, rent_price, premiere, discount)
        
        @name = name 
        @runtime = runtime 
        @categories = categories
        @release_date =release_date
        @directors =directors
        @actors = actors
        @price = price
        @rent_price = rent_price
        @premiere = premiere
        @discount = discount
    
    end
end
