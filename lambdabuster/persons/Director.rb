require_relative "Person"
module Director 
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

