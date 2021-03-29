require 'date'


class Person
    attr_accessor :name, :birthday, :nationality
    def initialize (name, birthday, nationality)
        @name = name
        @birthday = birthday
        @nationality = nationality
    end

    def to_s 
        @name  
    end
end

class Actor < Person
    attr_accessor :starred_in
    def initialize(name, birthday, nationality, starred_in = nil)
        super(name, birthday, nationality)
        @starred_in = starred_in
    end
end

class Director < Person
    attr_accessor :directed
    def initialize(name, birthday, nationality, directed = nil )
        super(name, birthday, nationality)
        @directed = directed
    end

end

# director = PersonType::Director.new("LaGordita", 1996-12-31,"VE")
# puts director.name
# puts director.birthday
# puts director.nationality



