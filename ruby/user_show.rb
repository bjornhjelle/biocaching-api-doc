# Requires: 
#  $ sudo gem install rest-client
# 

require 'rest-client'
require 'pp'

load './set_params.rb'

if ARGV.size < 2
  puts "usage:"
  puts "  ruby #{$0} server|localhost <id of user to show>"
  puts 
  exit 1
else
  text   = ARGV[1]
end 

begin
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("#{@server}/users/sign_in.json", params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  puts JSON.pretty_generate(JSON.parse(response))
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  response = RestClient.get "#{@server}/users/#{text}",  @http_headers

  puts response.code
  puts JSON.pretty_generate(JSON.parse(response))

rescue RestClient::Unauthorized => e
  puts "unauthorized, login failed."  
  
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
