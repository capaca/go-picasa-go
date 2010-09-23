require 'net/https'

def login(email, password, service='lh2')
  path = '/accounts/ClientLogin'
  http = Net::HTTP.new('www.google.com', 443)
  http.use_ssl=true

  data = "accountType=HOSTED_OR_GOOGLE&Email=#{email}&Passwd=#{password}&service=#{service}&source=BandManager"
  headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

  resp, data = http.post(path, data, headers)

  cl_string = data[/Auth=(.*)/, 1]
  cl_string
end

puts 'Logando no google...'
auth_token = login('pedro.capaca@gmail.com','ba159ga')

headers = {
  "Authorization" => "GoogleLogin auth=#{auth_token}",
  "Content-Type" => "application/atom+xml"
}

puts "Token de autoriazacao: #{auth_token}"

uri = URI.parse 'http://picasaweb.google.com/data/feed/api/user/pedro.capaca'
http = Net::HTTP.new(uri.host, uri.port)

data = ""
#data = "<entry xmlns='http://www.w3.org/2005/Atom' xmlns:media='http://search.yahoo.com/mrss/' xmlns:gphoto='http://schemas.google.com/photos/2007'><title type='text'>Trip To Italy</title><summary type='text'>This was the recent trip I took to Italy.</summary><gphoto:location>Italy</gphoto:location><gphoto:access>public</gphoto:access><gphoto:timestamp>1152255600000</gphoto:timestamp><media:group><media:keywords>italy, vacation</media:keywords></media:group><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#album'></category></entry>"

puts "Fazendo o post para um novo album..."
resp = http.post(uri.path, data, headers)
puts "Resposta do post: #{resp}"
