# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'


load './set_params.rb'

if ARGV.size < 2
  puts "usage:"
  puts "  ruby #{$0} server|localhost <observation id>"
  puts 
  exit 1
else
  text   = ARGV[1]
end 


begin
  
  response = RestClient.post("#{@server}/users/sign_in.json", @login_params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
  
  # @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  # response = RestClient.get "#{@server}/observations?size=1", @http_headers
  #
  # puts response.code
  # json = JSON.parse(response)
  # o_id = json["hits"][0]["_id"]
 
  puts "will like Observation with id: %d" % text
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  response = RestClient.post "#{@server}/observations/#{text}/like", nil, @http_headers
  
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
  
  response = RestClient.get "#{@server}/observations/#{text}/likes",  @http_headers
  
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
