# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'


load './params.rb'


begin
  
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("http://#{@server}/users/sign_in.json", params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  response = RestClient.get "http://#{@server}/observations?size=1", @http_headers

  puts response.code
  json = JSON.parse(response)
  pp json
  o_id = json["hits"][0]["_id"]
  p_id = json["hits"][0]["_source"]["primary_picture"]["id"]
 
  puts "picture id: %d" % p_id
  
  # @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  ##
  #response = RestClient.get "http://#{@server}/observations/#{o_id}/picture/#{p_id}/likes",  @http_headers
  response = RestClient.post "http://#{@server}/observations/#{o_id}/pictures/#{p_id}/like",  nil, @http_headers
  #
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  #
  #puts "get the likes:"
  #response = RestClient.get "http://#{@server}/pictures/#{p_id}/likes",  @http_headers
  #
   #puts response.code
   #json = JSON.parse(response)
   #puts JSON.pretty_generate(json)
  
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e

  puts e.message

  puts e.backtrace
  exit
end
