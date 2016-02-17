# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'
#params = {observation: {taxon_id: 7552, observed_at: Time.now.to_s, latitude: 60.123, longitude: 12.234, picture: File.new("flaggermus.jpg", 'rb')}, :multipart => true, :content_type => 'application/json'}

begin
  params = {user:{email:"bjorn@biocaching.com", password:"test1234"}}
  response = RestClient.post('http://localhost:3001/users/sign_in.json', params)
  token = JSON.parse(response)["authentication_token"]
  puts token
  #puts JSON.pretty_generate(json)
  
  # begge disse vil virke: 
  #params = {user_email:"bjorn@biocaching.com", user_token:token}
  #response = RestClient.get "http://localhost:3001/api/observations.json?user_email=bjorn@biocaching.com&user_token=#{token}"
    
    
  response = RestClient.get "http://localhost:3001/api/observations.json?all=true", {content_type: :json, accept: :json, 'X-User-Email' => 'bjorn@biocaching.com', 'X-User-Token' => token}
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
rescue RestClient::Unauthorized => e
  puts "unauthorized, try to log in with username and password..."
  
  

  # response = RestClient.post('http://localhost:3001/users/sign_in', params) do |response, request, result, &block|
#      if [301, 302, 307].include? response.code
#        redirected_url = response.headers[:location]
#        pp response.headers
#        response = RestClient.get 'http://localhost:3001/api/observations.json'
#        puts response.code
#
#      else
#        puts "her!"
#        puts response.class.name
#        json = JSON.parse(response)
#        #
#        puts JSON.pretty_generate(json)
#        response.return!(request, result, &block)
#      end
#    end
  
  
  
  #puts response.code
  
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
puts response.code
#pp response.cookies
#pp response.headers
