require 'json'
require_relative '../models/Person'
require_relative '../models/SearchList'
require_relative '../models/Movie'
line = "./test.json"
def readJson(path) 
    @directorsList = {}
    @actorsList = {}
    @moviesList = SearchList.new()
    @personsList = {}
    @categories = Set.new()
    file = File.read(path)
    data_hash = JSON.parse(file)
    result = true
    begin  # "try" block
        for director in data_hash['directors'] 
            if @personsList.keys.include?director['name'] || @directorsList.keys.include?director['name']
                throw "The Director: #{director['name'] has been registered before}"
            else
                auxDir = Director.new(director['name'],Date.parse(director['birthday']), director['nationality'])
                @directorsList[director['name']] = auxDir
                @personsList[director['name']] = auxDir
            end
            
        end
        for actor in data_hash['actors']
            if  @actorsList.keys.include?actor['name']
                throw "The Actor: #{actor['name'] has been registered before}"
                
            else
                auxAct = Actor.new(actor['name'],Date.parse(actor['birthday']), actor['nationality'])
                @actorsList[actor['name']] = auxAct
                if @personsList.keys.include?actor['name'] 
                    throw "The Actor: #{actor['name'] has been registered as director}"
                else 
                    @personsList[actor['name']] = auxAct
                end
            end
        end
        for movie in data_hash['movies']
            auxMov = loadMovie(movie)
            moviesList << auxMov
            for category in movie['categories']
                @categories << category
            end
        end
    rescue # optionally: `rescue Exception => ex`
        result =  false
        raise "Error to load JSON"
    ensure # will always get executed
        if result 
            return directorsList,actorsList,moviesList,categories,personsList
        else 
            return false        
        end
    end 
    
    # puts directorsList
    
end

def loadMovie(movieObj)
    movie = Movie.new(movieObj['name'],
        movieObj['runtime'],
        movieObj['categories'],
        Date.parse(movieObj['release_date']), 
        movieObj['directors'],
        movieObj['actors'],
        movieObj['price'],
        movieObj['rent_price'],
        movieObj['premiere'],
        movieObj['discount'])

    if movieObj['discount'] > 0
        movie = Discount.new(movie)
    end

    if movieObj['premiere'] == true
        movie = Premiere.new(movie)
    end
    return movie
end

dir,act = readJson(line)
puts dir 
puts act



