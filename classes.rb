require 'date'
class SearchList

    def initialize(*args)
        @list=args
    end
    def <<(elem)
        @list << elem
        self
    end
    def to_s
        string=""
        for elem in @list
            string = string+ elem.to_s + ", "
        end
        string[0..-3]
    end
    def +(other)
        base=SearchList.new(*@list)
        other.each do |x|
            base << x
        end
        base
    end
    def each(*args, &block)
        @list.each(*args, &block)
    end

    def scan(atom, &block)
        if not @list[0].class.method_defined? atom
            raise "El elemento no tiene dicho atributo"
        else
            list=SearchList.new()
            self.each do |x|
                elem=[x.method(atom).call].select &block
                if elem.length > 0
                    list<<x 
                end
            end
            list
        end
    end

    def length
        @list.length
    end
    def head
        @list.first
    end
end

class Person
    attr_accessor :name, :birthday, :nationality
    def initialize (name, birthday, nationality)
        @name = name
        @birthday = birthday
        @nationality = nationality
    end

    def to_s 
        "Name:" + " #{@name}.\n" + 
        "Birthday:" + " #{@birthday}.\n" + 
        "Nationality:" + " #{@nationality}.\n" 
    end
end

class Actor < Person
    attr_accessor :starred_in
    def initialize(name, birthday, nationality, starred_in = nil)
        super(name, birthday, nationality)
        @starred_in = starred_in
    end
end

class Director < Person
    attr_accessor :directed
    def initialize(name, birthday, nationality, directed = nil )
        super(name, birthday, nationality)
        @directed = directed
    end

end


class Currency
    # BASE EN ESTE MOMENTO ES DOLAR
    # Estos son los valores que hay que
    # multiplicar al valor para tener la cuenta en dolares

    BOLIVAR_TO_BASE = 0.00000053
    DOLAR_TO_BASE = 1
    EURO_TO_BASE = 1.18
    BITCOIN_TO_BASE = 56083.4

    attr_accessor :value, :base
    def initialize (value,base=1)
        @value = value
        @base = base
    end

    def to_s
        @value  
    end

    def in(atom)
        base_temp = self.value*self.base
        case atom
        when :bolivares
            value = (base_temp / BOLIVAR_TO_BASE).round(2)
            resp=Bolivar.new(value)
        when :dolars
            value = (base_temp / DOLAR_TO_BASE).round(2)
            resp=Dolar.new(value)
        when :euros
            value = (base_temp / EURO_TO_BASE).round(2)
            resp=Euro.new(value)
        when :bitcoins
            value = (base_temp / BITCOIN_TO_BASE).round(2)
            resp=Bitcoin.new(value)
        else
            raise "Solo se aceptan cambios a :dolars, :euros, :bolivares y :bitcoins"
        end
        resp.to_s
    end

    def compare(other)
        value_currency1=self.value / self.base
        value_currency2=other.value / other.base
        if value_currency1 < value_currency2
            :lesser
        elsif value_currency1 > value_currency2
            :greater
        else
            :equal
        end
    end
end


class Bolivar < Currency
    attr_accessor :starred_in
    def initialize(value)
        super(value,BOLIVAR_TO_BASE)
    end
    def to_s
        puts "#{self.value} bolivares"
        "#{self.value} bolivares"
    end
end

class Dolar < Currency
    attr_accessor :directed
    def initialize(value)
        super(value,DOLAR_TO_BASE)
    end
    def to_s
        puts "#{self.value} dolars"
        "#{self.value} dolars"
    end
end

class Euro < Currency
    attr_accessor :starred_in
    def initialize(value)
        super(value,EURO_TO_BASE)
    end
    def to_s
        puts "#{self.value} euros"
        "#{self.value} euros"
    end
end

class Bitcoin < Currency
    attr_accessor :directed
    def initialize(value)
        super(value,BITCOIN_TO_BASE)
    end
    def to_s
        puts "#{self.value} bitcoins"
        "#{self.value} bitcoins"
    end
end

module CurrencyTypeExtension
    def dolars()
        Dolar.new(self)
    end
    def euros()
        Euro.new(self)
    end
    def bolivares()
        Bolivar.new(self)
    end
    def bitcoins()
        Bitcoin.new(self)
    end
end

class Integer
    include CurrencyTypeExtension
end

class Float
    include CurrencyTypeExtension
end

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
module BuyOrder
    def buy_order(transaction)
        transaction.total=transaction.movie.price
        transaction.date=Date.today
    end
end

module RentOrder
    def rent_order(transaction)
        transaction.total=transaction.movie.rent_price
        transaction.date=Date.today+2
    end
end


class Transaction
    include BuyOrder
    include RentOrder
    attr_accessor :movie, :type, :total, :date
        def initialize(movie, type)
            @movie=movie
            @type=type
            @total=0
            @date=Date.today
        end
        
end

class User
    attr_accessor :owned_movies, :rented_movies, :transactions
    def initialize()
        @owned_movies=SearchList.new()
        @rented_movies=SearchList.new()
        @transactions=SearchList.new()
    end
end


