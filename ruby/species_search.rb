# Requires: 
#  $ sudo gem install rest-client
# 
#
require 'rest-client'
response = RestClient.get 'http://bc:Oslo2016@api.biocaching.com:81/taxonomies/1/taxa/search.json', {:params => {:term => 'fox'}}

json = JSON.parse(response)

puts JSON.pretty_generate(json)

puts "Total number of hits: %i" % json["total"]
puts "Number of hits returned: %i" % json["number_of_hits"]

for hit in json["hits"] do 
  common_names = hit["_source"]["common_names"]
  scientific_name = hit["_source"]["scientific_name"]
  common_name_highlight = hit["highlight"]["common_names.name"].nil? ? "" : hit["highlight"]["common_names.name"].first
  scientfic_name_highlight = hit["highlight"]["scientific_name"].nil? ? "" : hit["highlight"]["scientific_name"].first
  if common_names.empty?
    puts "no common name (%s) highlight: %s" % [scientific_name[0], scientfic_name_highlight]
  else
    puts "%s (%s) highlight: %s, %s" % [common_names[0]["name"], scientific_name, common_name_highlight, scientfic_name_highlight]
  end 
end