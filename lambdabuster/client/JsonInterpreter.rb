require 'json'
require 'set'
require 'wannabe_bool'
require_relative '../models/Person'
require_relative '../models/SearchList'
require_relative '../models/Movie'
line = "./test.json"
def readJson(path) 
    @directorsList = {}
    @actorsList = {}
    @moviesList = SearchList.new()
    @moviesChecker = {}
    @personsList = {}
    @categories = Set.new
    file = File.read(path)
    data_hash = JSON.parse(file)
    result = true
    begin  # "try" block
        for director in data_hash['directors'] 
            if @directorsList.keys.include? director['name']
                throw "The Director: #{director['name']} has been registered before"
            else
                auxDir = Director.new(director['name'],Date.parse(director['birthday']), director['nationality'])
                @directorsList[director['name']] = auxDir
                @personsList[director['name']] = auxDir
            end
            
        end
        for actor in data_hash['actors']
            if  @actorsList.keys.include?actor['name']
                throw "The Actor: #{actor['name']} has been registered before"
                
            else
                auxAct = Actor.new(actor['name'],Date.parse(actor['birthday']), actor['nationality'])
                @actorsList[actor['name']] = auxAct
                if @personsList.keys.include?actor['name'] 
                    throw "The Actor: #{actor['name']} has been registered as director"
                else 
                    @personsList[actor['name']] = auxAct
                end
            end
        end
        for movie in data_hash['movies']
            # puts movie
            if @moviesChecker.keys.include?movie['name']
                throw "The Movie: #{movie['name']} has been registered before"
            else
                # puts loadMovie(movie)
                auxMov = loadMovie(movie)
                @moviesList << auxMov
                @moviesChecker[movie['name']]= auxMov
                for category in movie['categories']
                    @categories << category
                end
            end
            
        end
    rescue StandardError => e# optionally: `rescue Exception => ex`
        result =  false
        puts e
        raise "Error to load JSON"
    ensure # will always get executed
        # puts "Movies #{@moviesList}"

        if result 
            return @directorsList,@actorsList,@moviesList,@categories,@personsList
        else 
            return false
        end
    end 
    
    # puts directorsList
    
end

def loadMovie(movieObj)
    # puts "We are in load"
    # puts movieObj
    begin
        movie = Movie.new(
            movieObj['name'],
            Integer(movieObj['runtime']),
            movieObj['categories'],
            Date.parse(movieObj['release_date']), 
            movieObj['directors'],
            movieObj['actors'],
            Float(movieObj['price']),
            Float(movieObj['rent_price']),
            movieObj['premiere'],
            Integer(movieObj['discount'])
        )
        if Integer(movieObj['discount']) > 0
            movie = Discount.new(movie)
        end
    
        if movieObj['premiere'] == true
            movie = Premiere.new(movie)
        end
    rescue StandardError => e
        puts e
    ensure
        return movie
    end  

    
    movie
end

dir,act,b,d,g = readJson(line)
# puts "Directors #{dir}"
puts "Movies #{b}"




