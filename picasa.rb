require 'net/https'

def login(email, password, service='lh2')
  path = '/accounts/ClientLogin'
  http = Net::HTTP.new('www.google.com', 443)
  http.use_ssl=true

  data = "accountType=HOSTED_OR_GOOGLE&Email=#{email}&Passwd=#{password}&service=#{service}&source=BandManager"
  headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

  resp, data = http.post(path, data, headers)

  cl_string = data[/Auth=(.*)/, 1]
  headers["Authorization"] = "GoogleLogin auth=#{cl_string}"
end

def retrieve_albums(userid='pedro.capaca')
  http = Net::HTTP.new('picasaweb.google.com', 80)
  http.get "/data/feed/api/user/#{userid}"
end

class PicasaAlbum
  def initialize(entry_hash)
    @id = entry_hash["id"][1]
    @title = entry_hash["title"][0]["content"]
    @author_name = entry_hash["author"][0]["name"][0]
    @author_uri = entry_hash["author"][0]["uri"][0]
    @timestamp = entry_hash["timestamp"][0]
    @num_photos = entry_hash["numphotos"][0].to_i
    @user = entry_hash["user"][0]
    @nickname = entry_hash["nickname"][0]
    @commenting_enable = entry_hash["commentingEnabled"][0] == "true" ? true : false
    @comment_count = entry_hash["commentCount"][0].to_i
  end
  
  attr_reader :id, :title, :author_name, :author_uri, :timestamp, :num_photos, 
              :user, :nickname, :commenting_enable, :comment_count
end
