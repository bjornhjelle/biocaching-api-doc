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
  p_id = json["hits"][0]["_source"]["picture"]["id"]
 
  puts "picture id: %d" % p_id
  
  
  like_id = nil
  if !json["hits"][0]["_source"]["picture"].nil?
    if !json["hits"][0]["_source"]["picture"]["likes"].nil?
      for like in json["hits"][0]["_source"]["picture"]["likes"] do
        puts "like id: %s" % like["id"]
        puts "like user_id: %s" % like["user"]["email"]
        if like["user"]["email"] == @username
          like_id = like["id"]
        end
      end
    end
  end
  
  if like_id.nil?
    puts "could not find a like to delete"
    exit
  end
  
  
  # @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  ##
  #response = RestClient.get "http://#{@server}/observations/#{o_id}/picture/#{p_id}/likes",  @http_headers
  response = RestClient.post "http://#{@server}/observations/#{o_id}/pictures/#{p_id}/unlike", nil,   @http_headers
  #
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  #
 # puts "get the likes:"
#  response = RestClient.get "http://#{@server}/pictures/#{p_id}/likes",  @http_headers
  #
   puts response.code
   json = JSON.parse(response)
   puts JSON.pretty_generate(json)
  
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e

  puts e.message
  #puts e.response

  puts e.backtrace
  exit
end
