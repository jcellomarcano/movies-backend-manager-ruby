require 'date'


class Person
    attr_accessor :name, :birthday, :nationality
    def initialize (name, birthday, nationality)
        @name = name
        @birthday = Date.new(birthday)
        @nationality = nationality
    end

    def to_s 
        @name  
    end
end
module Person
    class Actor < Person
        def initialize(name, birthday, nationality, starred_in = nil)
            super(name, birthday, nationality)
            @starred_in = starred_in
        end
    end

    class Director < Person::Person
        def initialize(name, birthday, nationality, directed = nil )
            super(name, birthday, nationality)
            @directed = directed
        end
        def test 
            puts "Test"
        end

    end
    
end




