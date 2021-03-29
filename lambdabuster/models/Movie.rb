require 'date'
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

class Premiere 

    def initialize(movie)
        @movie = movie
        # super(movie)
    end

    def price 
        @movie.price*2
    end

    def rent_price 
        @movie.rent_price*2
    end

    #used for access to attr of movies by methods (didn't found a more efficient way to use decorator and access to the attr of movie)

    def name 
        @movie.name 
    end
    def runtime 
        @movie.runtime 
    end
    def categories 
        @movie.categories
    end
    def release_date 
        @movie.release_date
    end
    def directors 
        @movie.directors
    end
    def actors 
        @movie.actors
    end
end

class Discount 
    #used for access to attr of movies by methods (didn't found a more efficient way to use decorator and access to the attr of movie)
    def initialize(movie)
        @movie = movie
        # super(movie)
    end
    def name 
        @movie.name 
    end
    def runtime 
        @movie.runtime 
    end
    def categories 
        @movie.categories
    end
    def release_date 
        @movie.release_date
    end
    def directors 
        @movie.directors
    end
    def actors 
        @movie.actors
    end
    def price 
        @movie.discount.priceDiscounted(@movie.price)
    end
    def rent_price 
        @movie.discount.priceDiscounted(@movie.price)
    end
    def premiere 
        @movie.premiere 
    end
    def discount 
        @movie.discount
    end
end

class Numeric
    def priceDiscounted(n)
      (1 - (self.to_f / 100.0)) * n.to_f
    end
end

movie = Movie.new("Hola", 120, "GustoDeGordita",Date.parse("2020-07-05"),
"Juan", "juano y juana", 11.02, 1, true,50)

if movie.premiere
    premiere = Premiere.new(movie)

    puts premiere.name
    puts premiere.price
else
    premiere = Discount.new(movie)

    puts premiere.name
    puts premiere.price
    
end
