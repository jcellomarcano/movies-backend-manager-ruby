require_relative "Person"
module Actor 
    class Actor < Person::Person
        def initialize(name, birthday, nationality, star = nil)
            super(name, birthday, nationality)
            @starred_in = starred_in
        end
    end
end