if ARGV.size < 1
  puts "usage:"
  puts "  ruby #{$0} server|localhost "
  puts 
  exit 1
end 

if ARGV[0] == 'server'
  @server   = "https://api.biocaching.com"
  @username = "bjorn@biocaching.com"
  @password = "test1234"
  @http_headers = {accept: :json, 'X-User-Api-Key' => '2e71d090e75e1232c4414bbe96f08ee8'}
else
  @server   = "http://localhost:3001"
  @username = "bjorn@biocaching.com"
  @password = "test1234"
  @http_headers = {accept: :json, 'X-User-Api-Key' => '621f85bdc3482ec12991019729aa9315', referer: 'http://localhost'}
end

@login_params = {user:{email:@username, password:@password}}
@sign_in_url = "#{@server}/users/sign_in"