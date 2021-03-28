require 'json'
require_relative '../models/Person'
line = "./test.json"
file = File.read(line)
data_hash = JSON.parse(file)
for director in data_hash['directors'] 
    puts director
end


