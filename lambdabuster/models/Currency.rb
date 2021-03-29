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

# 15.dolars.in(:euros)
# x=15.dolars.compare(12.euros)
# puts "#{x}"
# 14000000.58.bolivares.in(:dolars)
