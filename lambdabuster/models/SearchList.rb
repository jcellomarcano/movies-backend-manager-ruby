require_relative 'Person'
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

    def scan(atom:, &block)
        new_search=SearchList.new()
        
    end
end

hola = SearchList.new(2,5,3)
hola<<8
puts "#{hola.to_s}"
p=Person.new("Martin Charles Scorsese",Date.new(1942,11,17),"United States")
puts "#{p.to_s}"
directors=SearchList.new(Person.new(
"Martin Charles Scorsese",
Date.new(1942,11,17),
"United States"
),
Person.new(
"Cristopher Edward Nolan",
Date.new(1970,7,30),
"United Kingdom"
))
directors.each do |x|
    puts "#{x}"
  end
nueva=directors+hola
puts "Nueva: #{nueva.to_s}"
puts "Directors: #{directors.to_s}"
x=SearchList.new()
puts "Directors: #{x.to_s}"
