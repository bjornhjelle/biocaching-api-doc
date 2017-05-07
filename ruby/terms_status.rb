# Requires: 
#  $ sudo gem install rest-client
# 
#
require 'rest-client'

load './set_params.rb'

require 'pp'

begin
  response = RestClient.post("#{@server}/users/sign_in.json", @login_params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  response = RestClient.get "#{@server}/terms/status.json", @http_headers

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
