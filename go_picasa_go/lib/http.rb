# Module that offers methods to do the basic HTTP requests to services provided
# by Picasa like login, retrieve albums and etc.

module Picasa::HTTP
  
  GOOGLE_HOST = 'www.google.com'
  PICASA_HOST = 'picasaweb.google.com'
  
  LOGIN_PATH = '/accounts/ClientLogin'
  LOGIN_PORT = 443
  
  ALBUMS_PATH = "/data/feed/api/user/"
  
  PICASA_SERVICE = 'lh2'
  APP_NAME = 'BandManager'
  
  # Do a post request to authenticate user with the e-mail and password provided
  # and return the response and data of the request
  
  def self.authenticate email, password
    http = Net::HTTP.new(GOOGLE_HOST, LOGIN_PORT)
    http.use_ssl=true

    data = %{ 
      accountType=HOSTED_OR_GOOGLE&Email=#{email}&Passwd=#{password}&
      service=#{PICASA_SERVICE}&source=#{APP_NAME}"
    }
    
    headers = {'Content-Type' => 'application/x-www-form-urlencoded'}
    resp, data = http.post(LOGIN_PATH, data, headers)
    
    #@auth_token = data[/Auth=(.*)/, 1]
    #self
  end
  
  # Do a get request to retrueve all the albums from a user using the user_id. 
  # The auth_token parameter is optional since it only retrieves more 
  # information about each album.
  
  def self.get_albums user_id, auth_token = nil

    headers = {
      "Authorization" => "GoogleLogin auth=#{auth_token}",
      "Content-Type" => "application/atom+xml"
    }
    
    http = Net::HTTP.new(PICASA_HOST, 80)
    http.get("#{ALBUMS_PATH}#{user_id}", headers)
  end
