require 'date'
module Person
    class Person
        attr_accessor :name, :birthday, :nationality
        def initialize (name, birthday, nationality)
            @name = name
            @birthday = Date.new(birthday)
            @nationality = nationality
        end

        def to_s 
          puts @name  
        end
    end
    
end

# persona = Person::Person.new("Mafermazu", 1996-07-02, "VE")
# persona.to_s
# puts persona.name



