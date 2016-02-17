# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'
params = {observation: {taxon_id: 7552, observed_at: Time.now.to_s, latitude: 60.123, longitude: 12.234, picture: File.new("flaggermus.jpg", 'rb')}, :multipart => true, :content_type => 'application/json'}

begin
  
  response = RestClient.post 'http://localhost:3000/api/observations', params
  puts response.code
rescue RestClient::Unauthorized => e
  puts "unauthorized, will add username and password and try to again..."
  params = params.merge(user:{email:"bjorn@biocaching.com", password:"test1234"})
  response = RestClient.post 'http://localhost:3000/api/observations', params
  puts response.code
  
  exit
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
#
json = JSON.parse(response)
#
puts JSON.pretty_generate(json)

puts response.code
pp response.cookies
pp response.headers