# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'

load './set_params.rb'

begin
  response = RestClient.post(@sign_in_url, @login_params, @http_headers)

  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  put_params = {settings: {languages: "eng", :tag_list => "bjorn"}, :content_type => 'application/json'}
  response = RestClient.put "#{@server}/settings", put_params, @http_headers
  
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
