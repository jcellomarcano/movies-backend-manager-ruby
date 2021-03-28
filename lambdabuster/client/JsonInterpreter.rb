require 'json'
# require_relative '../models/Person'
require_relative '../models/SearchList'
require_relative '../models/Movie'
line = "./test.json"
def readJson(path) 
    directorsList = SearchList.new()
    actorsList = SearchList.new()
    moviesList = SearchList.new()
    file = File.read(path)
    data_hash = JSON.parse(file)
    result = true
    begin  # "try" block
        for director in data_hash['directors'] 
            auxDir = PersonType::Director.new(director['name'],Date.parse(director['birthday']), director['nationality'])
            directorsList << auxDir
        end
        for actor in data_hash['actors']
            auxAct = PersonType::Actor.new(actor['name'],Date.parse(actor['birthday']), actor['nationality'])
            actorsList << auxAct
        end
        for movie in data_hash['movies']
            # auxAct = PersonType::Actor.new(actor['name'],Date.parse(actor['birthday']), actor['nationality'])
            # actorsList << auxAct
        end
    rescue # optionally: `rescue Exception => ex`
        result =  false
        raise "Error to load JSON"
    ensure # will always get executed
        if result 
            return directorsList,actorsList
        else 
            return false        
        end
    end 
    
    # puts directorsList
    
end

dir,act = readJson(line)
puts dir 
puts act



