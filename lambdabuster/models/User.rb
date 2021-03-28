require './SearchList'
class User
    attr_accessor :owned_movies, :rented_movies, :transactions
    def initialize()
        @owned_movies=SearchList.new()
        @rented_movies=SearchList.new()
        @transactions=SearchList.new()
    end
end