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
end
