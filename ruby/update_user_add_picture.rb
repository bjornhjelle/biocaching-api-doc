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
  puts "  ruby #{$0} server|localhost  <filename of picture to add>"
  puts 
  exit 1
else
  filename   = ARGV[1]
end 



begin
  
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("#{@server}/users/sign_in.json", @login_params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
 
  puts "will add picture to the logged in user" 
  
  picture_params = {picture_attributes: {primary: false, picture: File.new(filename, 'rb')}, :multipart => true, :content_type => 'application/json'}
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  response = RestClient.post "#{@server}/user/picture", picture_params, @http_headers
  
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
