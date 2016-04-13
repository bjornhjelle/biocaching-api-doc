# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'


load './params.rb'


observation_params = {observation: {taxon_id: 80274, comments: "Observert i hagen min", observed_at: Time.now.to_s, latitude: 58.123, longitude: 11, picture: File.new("../pictures/blåmeis.jpg", 'rb')}, :multipart => true, :content_type => 'application/json'}

begin
  
  pp @http_headers
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("http://#{@server}/users/sign_in.json", params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  response = RestClient.post "http://#{@server}/observations", observation_params, @http_headers
  
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
