class Currency
    BOLIVAR_TO_BASE = 0.00053
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
            resp = (base_temp / BOLIVAR_TO_BASE).round(2)
            puts "#{resp} bolivares"
        when :dolars
            resp = (base_temp / DOLAR_TO_BASE).round(2)
            puts "#{resp} dolares"
        when :euros
            resp = (base_temp / EURO_TO_BASE).round(2)
            puts "#{resp} euros"
        when :bitcoins
            resp = (base_temp / BITCOIN_TO_BASE).round(2)
            puts "#{resp} bitcoins"
        else
            raise "Solo se aceptan cambios a :dolars, :euros, :bolivares y :bitcoins"
        end
        resp
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

module CurrencyType
    BOLIVAR_TO_BASE = 0.00000053
    DOLAR_TO_BASE = 1
    EURO_TO_BASE = 1.18
    BITCOIN_TO_BASE = 56083.4

    class Bolivar < Currency
        attr_accessor :starred_in
        def initialize(value)
            super(value,BOLIVAR_TO_BASE)
        end
        
    end

    class Dolar < Currency
        attr_accessor :directed
        def initialize(value)
            super(value,DOLAR_TO_BASE)
        end

    end

    class Euro < Currency
        attr_accessor :starred_in
        def initialize(value)
            super(value,EURO_TO_BASE)
        end
    end

    class Bitcoin < Currency
        attr_accessor :directed
        def initialize(value)
            super(value,BITCOIN_TO_BASE)
        end

    end
    
end

module CurrencyTypeExtension
    def dolars()
        CurrencyType::Dolar.new(self)
    end
    def euros()
        CurrencyType::Euro.new(self)
    end
    def bolivares()
        CurrencyType::Bolivar.new(self)
    end
    def bitcoins()
        CurrencyType::Bitcoin.new(self)
    end
end

class Integer
    include CurrencyTypeExtension
end

class Float
    include CurrencyTypeExtension
end

15.dolars.in(:euros)
x=15.dolars.compare(12.euros)
puts "#{x}"
14000000.58.bolivares.in(:dolars)
