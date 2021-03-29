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

    def to_s
        
        hours = @runtime / 60
        duration = "#{hours}h #{@runtime - (hours * 60)} min"
        movieFormat = "#{@name} (#{@release_date.year}) - #{duration}\n"
        movieFormat += "Genres: "
        catList = @categories.first @categories.size - 1
        catList.each { |categInstance| movieFormat += "#{categInstance}, " }    
        movieFormat += @categories[-1].to_s + "\n"
        movieFormat += "Directed by: "
        movieFormat += @directors.to_s + "\n"
        movieFormat += "Cast: "
        movieFormat += @actors.to_s + "\n"
        movieFormat
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
    def to_s
        @movie.to_s
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
    def to_s
        @movie.to_s
    end
end

class Numeric
    def priceDiscounted(n)
      (1 - (self.to_f / 100.0)) * n.to_f
    end
end


