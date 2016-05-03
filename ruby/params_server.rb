puts
if ARGV.size < 3
  puts "usage:"
  puts "  ruby <script>.rb <APIHOST> <username> <password>"
  puts "  for example: ruby list_observations.rb api.biocaching.com:82 bjorn@biocaching.com password"
  puts 
  exit 1
else
  @server   = ARGV[0]
  @username = ARGV[1]
  @password = ARGV[2]
end  

#@http_headers = {content_type: :json, accept: :json}
@http_headers = {accept: :json, 'X-User-Api-Key' => '2e71d090e75e1232c4414bbe96f08ee8'}
