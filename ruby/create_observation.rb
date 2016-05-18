# Requires: 
#  $ sudo gem install rest-client
# 


require 'rest-client'
require 'pp'

load './set_params.rb'

observation_params = {
   observation: { 
     taxon_id: 61057, 
     observed_at: Time.now.to_s, 
     latitude: 65.123, 
     longitude: 14.234, 
     is_public: false,
     picture_attributes: { 
       primary: true, 
       picture: File.new("greylag_goose.jpg", 'rb')
       }, 
     coordinate_uncertainty_in_meters: 30, 
     individual_count: 5, 
     sex: "3 males, 2 females", 
     comment: "dette er en kommentar...",
     life_stage: "4 adults, 1 juvenile",
     tag_list: "tromsø bioblitzmai2015",
     add_tags_from_settings: false
     }, 
   multipart: true, 
   content_type: 'application/json'}

begin
  
  response = RestClient.post("#{@server}/users/sign_in.json", @login_params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  response = RestClient.post "#{@server}/observations", observation_params, @http_headers
  
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e

  puts e.message
  puts e.response.code
  pp e.response
end
