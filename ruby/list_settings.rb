# Requires: 
#  $ sudo gem install rest-client
# 



require 'rest-client'
require 'pp'

load './params.rb'

begin
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("http://#{@server}/users/sign_in.json", params)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
  search_params= "latitude=60&longitude=11&distance=2000km&size=5&from=0&"
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  response = RestClient.get "http://#{@server}/api/settings", @http_headers
  
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
