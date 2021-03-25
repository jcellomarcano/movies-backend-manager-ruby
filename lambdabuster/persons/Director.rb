require Person

class Director < Person
    def test 
        puts "Test"
    end

end

directo = Director.new("Cameron", "23/12/1995","VE")
puts directo.name
puts directo.test