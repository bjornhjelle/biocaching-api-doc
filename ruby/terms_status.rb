# Requires: 
#  $ sudo gem install rest-client
# 
#
require 'rest-client'

load './params.rb'

require 'pp'

begin
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("http://#{@server}/users/sign_in.json", params)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)

  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  puts "will accept terms:"

  response = RestClient.get "http://#{@server}/terms/status.json", @http_headers

  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  

  
rescue RestClient::Unauthorized => e
  puts "unauthorized, login failed."  
  
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
