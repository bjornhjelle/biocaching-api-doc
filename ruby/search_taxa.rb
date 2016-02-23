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

  response = RestClient.get "http://#{@server}/api/taxonomies/1/taxa/search.json?term=rev&languages=nno", @http_headers

  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)

  puts "Total number of hits: %i" % json["total"]
  puts "Number of hits returned: %i" % json["number_of_hits"]

  for hit in json["hits"] do 
    pp hit
    # common_names = hit["_source"]["names"]["eng"]
    # scientific_name = hit["_source"]["scientific_name"]
    # common_name_highlight = hit["highlight"]["names.eng"].nil? ? "" : hit["highlight"]["names.eng"].first
    # scientfic_name_highlight = hit["highlight"]["scientific_name"].nil? ? "" : hit["highlight"]["scientific_name"].first
    # if common_names.empty?
    #   puts "no common name (%s) highlight: %s" % [scientific_name[0], scientfic_name_highlight]
    # else
    #   puts "%s (%s) highlight: %s, %s" % [common_names[0], scientific_name, common_name_highlight, scientfic_name_highlight]
    # end 
  end
  
  
rescue RestClient::Unauthorized => e
  puts "unauthorized, login failed."  
  
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
