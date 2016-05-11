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
  o_id = json["hits"][0]["_id"]
  pp json["hits"][0]["_source"]["pictures"]
  
  p_id = nil
  picture = json["hits"][0]["_source"]["other_pictures"].first
  if picture["primary"] == false
    puts "is not primary, will set: %i" % picture["id"]
    p_id = picture["id"]
  else
    puts "should be false, will exit"
    exit
  end
    
    
 
  puts "will change primary picture of observation with id: %d" % o_id
  
  # picture_params = {picture_attributes: {primary: false, picture: File.new("greylag_2.jpg", 'rb')}, :multipart => true, :content_type => 'application/json'}
  #

  response = RestClient.patch "http://#{@server}/observations/#{o_id}/pictures/#{p_id}/primary", nil, @http_headers
  #
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
  
  
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e

  puts e.message
  puts e.response

  puts e.backtrace
  exit
end
