require 'json'
require_relative '../models/Person'
require_relative '../models/SearchList'
line = "./test.json"
def readJson(path) 
    directorsList = SearchList.new()
    file = File.read(path)
    data_hash = JSON.parse(file)
    for director in data_hash['directors'] 
        auxDir = PersonType::Director.new(director['name'],Date.parse(director['birthday']), director['nationality'])
        directorsList << auxDir
    end
    # puts directorsList
    return directorsList
end

searchListica = readJson(line)
puts searchListica



