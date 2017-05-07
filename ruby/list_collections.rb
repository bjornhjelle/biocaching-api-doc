# Requires: 
#  $ sudo gem install rest-client
# 



require 'rest-client'
require 'pp'

load './set_params.rb'

if ARGV.size > 1
  id = ARGV[1]
end 



begin
  response = RestClient.post(@sign_in_url, @login_params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  #puts JSON.parse(response)
    
  params = id.nil? ? "" : ("/" + id)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})  
  
  response = RestClient.get "#{@server}/collections" + params, @http_headers
  
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
