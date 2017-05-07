# Requires: 
#  $ sudo gem install rest-client
# 
#
require 'rest-client'

load './set_params.rb'

require 'pp'

begin
  
  # NB! denne fungerer ikke - vi bør ikke bruke Devise til dette
  
  @user_params = {user:{email:"bjorn@biocaching.com"}}
  response = RestClient.post("#{@server}/users/password.json", @user_params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
  

  
rescue RestClient::Unauthorized => e
  puts "unauthorized, login failed."  
  
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
