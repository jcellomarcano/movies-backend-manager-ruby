require 'json'
line = "./test.json"
file = File.read(line)
data_hash = JSON.parse(file)
puts data_hash['directors']