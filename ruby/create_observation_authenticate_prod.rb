# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'
observation_params = {observation: {taxon_id: 7552, observed_at: Time.now.to_s, latitude: 60.123, longitude: 12.234, picture: File.new("gekko.jpg", 'rb')}, :multipart => true, :content_type => 'application/json'}

authenticate_params = {user:{email:"bjorn@biocaching.com", password:"test1234"}}

http_headers = {content_type: :json, accept: :json}
SERVER ="http://api.biocaching.com:82"

begin
  # authenticate
  response = RestClient.post("#{SERVER}/users/sign_in.json", authenticate_params)
  puts "response..."
  token = JSON.parse(response)["authentication_token"]
  puts "Successfully authenticated, token: %s" % token
  
  http_headers.merge!({'X-User-Email' => 'bjorn@biocaching.com', 'X-User-Token' => token})
  
  response = RestClient.post "#{SERVER}/api/observations", observation_params, http_headers
  
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
