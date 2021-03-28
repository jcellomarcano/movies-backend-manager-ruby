require_relative "Person"
module Director 
    class Director < Person::Person

        def initialize(name, birthday, nationality)
            super(name, birthday, nationality)
        end
        def test 
            puts "Test"
        end

    end

end

directo = Director::Director.new("Cameron", 1996-07-02, "VE")
puts directo.test
directo.to_s