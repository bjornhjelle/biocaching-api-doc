puts
if ARGV.size < 3
  puts "usage:"
  puts "  ruby list_observations.rb <APIHOST> <username> <password>"
  puts "  for example: ruby list_observations.rb api.biocaching.com:82 bjorn@biocaching.com my_password123"
  puts 
  exit 1
else
  @server   = ARGV[0]
  @username = ARGV[1]
  @password = ARGV[2]
end  

@http_headers = {content_type: :json, accept: :json}