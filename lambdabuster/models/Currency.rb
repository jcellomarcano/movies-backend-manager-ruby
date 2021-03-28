class Currency
    attr_accessor :value
    def initialize (value,base=1)
        @value = value
        @base = base
    end

    def to_s
        @value  
    end

    def in(atom)
        base = self.value*self.base
        case atom
        when :bolivares
            resp = base * BOLIVAR_TO_DOLAR
        when :dolars
            resp = base * DOLAR_TO_DOLAR
        when :euros
            resp = base * EURO_TO_DOLAR
        when :bitcoins
            resp = base * BITCOIN_TO_DOLAR
        else
            raise "Solo se aceptan cambios a :dolars, :euros, :bolivares y :bitcoins"
    end
end

module CurrencyType
    BOLIVAR_TO_DOLAR = 0.00053
    DOLAR_TO_DOLAR = 1
    EURO_TO_DOLAR = 1.18
    BITCOIN_TO_DOLAR = 56083.4

    class Bolivar < Currency
        attr_accessor :starred_in
        def initialize(value)
            super(value,BOLIVAR_TO_DOLAR)
        end
        
    end

    class Dolar < Currency
        attr_accessor :directed
        def initialize(value)
            super(value,DOLAR_TO_DOLAR)
        end

    end

    class Euro < Currency
        attr_accessor :starred_in
        def initialize(value)
            super(value,EURO_TO_DOLAR)
        end
    end

    class Bitcoin < Currency
        attr_accessor :directed
        def initialize(value)
            super(value,BITCOIN_TO_DOLAR)
        end

    end
    
end

module CurrencyTypeExtension
    def dolars(value)
        CurrencyType::Dolar.new(value)
    end
    def euros(value)
        CurrencyType::Euro.new(value)
    end
    def bolivares(value)
        CurrencyType::Bolivar.new(value)
    end
    def bitcoins(value)
        CurrencyType::Bitcoin.new(value)
    end
end

class Integer
    include CurrencyTypeExtension
end

class Float
    include CurrencyTypeExtension
end

euros=15.dolars.in(:euros)
puts euros