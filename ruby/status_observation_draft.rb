# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'


load './set_params.rb'


begin
  
  response = RestClient.post("#{@server}/users/sign_in.json", @login_params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  user_id = JSON.parse(response)["id"]
  
  puts JSON.parse(response)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  response = RestClient.get "#{@server}/observations?size=1&user_id=#{user_id}", @http_headers

  puts response.code
  json = JSON.parse(response)
  o_id = json["hits"][0]["_id"]
 
  puts "will set to status draft for Observation with id: %d" % o_id
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  response = RestClient.post "#{@server}/observations/#{o_id}/draft", nil, @http_headers
  
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
