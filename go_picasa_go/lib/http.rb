# Module that offers methods to do the basic HTTP requests to services provided
# by Picasa like login, retrieve albums and etc.

#TODO Refatorar os headers e objetos http onde possivel
module Picasa::HTTP
  
  GOOGLE_HOST = 'www.google.com'
  PICASA_HOST = 'picasaweb.google.com'
  
  LOGIN_PATH = '/accounts/ClientLogin'
  LOGIN_PORT = 443
  
  ALBUMS_PATH = "/data/feed/api/user/$user_id$"
  SINGLE_ALBUM_PATH = "/data/entry/api/user/$user_id$/albumid/$album_id$"
  
  PICASA_SERVICE = 'lh2'
  APP_NAME = 'BandManager'
  
  # Do a post request to authenticate user with the e-mail and password provided
  # and return the response and data of the request
  
  def self.authenticate email, password
    http = Net::HTTP.new(GOOGLE_HOST, LOGIN_PORT)
    http.use_ssl=true

    data = "accountType=HOSTED_OR_GOOGLE&Email=#{email}&Passwd=#{password}&service=#{PICASA_SERVICE}&source=#{APP_NAME}"
    
    headers = {'Content-Type' => 'application/x-www-form-urlencoded'}
    resp, data = http.post(LOGIN_PATH, data, headers)
    
    #@auth_token = data[/Auth=(.*)/, 1]
    #self
  end
  
  # Do a post request to create an album into the user account. 
  # The attributes used to create the album are:
  #
  # title, summary, location, keywords

  def self.post_album user_id, auth_token, params
    headers = {
      "Authorization" => "GoogleLogin auth=#{auth_token}",
      "Content-Type" => "application/atom+xml"
    }
    uri = URI.parse "http://picasaweb.google.com/data/feed/api/user/#{user_id}"
    http = Net::HTTP.new(uri.host, uri.port)
    
    #TODO Extract the XML below to file and use a template engine to render it.
    data = "<entry xmlns='http://www.w3.org/2005/Atom' xmlns:media='http://search.yahoo.com/mrss/' xmlns:gphoto='http://schemas.google.com/photos/2007'><title type='text'>#{params[:title]}</title><summary type='text'>#{params[:summary]}</summary><gphoto:location>#{params[:location]}</gphoto:location><gphoto:access>public</gphoto:access><gphoto:timestamp>#{Time.now.to_i}000</gphoto:timestamp><media:group><media:keywords>#{params[:keywords]}</media:keywords></media:group><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#album'></category></entry>"
    return http.post(uri.path, data, headers)
  end
  
  # Do a put request to update album data
  
  def self.update_album user_id, album_id, auth_token, params
    
    resp, data = get_album user_id, album_id, auth_token
    
    raise :error unless resp.code == "200"

    update_album_xml data, params 
    
    headers = {
      "Authorization" => "GoogleLogin auth=#{auth_token}",
      "Content-Type" => "application/atom+xml",
      "If-Match" => "*"
    }
    uri = URI.parse "http://picasaweb.google.com/data/entry/api/user/#{user_id}/albumid/#{album_id}"
    http = Net::HTTP.new(uri.host, uri.port)
    http.send_request('PUT',uri.path, data, headers)
  end
  
  # Do a delete request to delete an album from a user
  
  def self.delete_album user_id, album_id, auth_token
    headers = {
      "Authorization" => "GoogleLogin auth=#{auth_token}",
      "Content-Type" => "application/atom+xml",
      "If-Match" => "*"
    }
    uri = URI.parse "http://picasaweb.google.com/data/entry/api/user/#{user_id}/albumid/#{album_id}"
    http = Net::HTTP.new(uri.host, uri.port)
    http.send_request('DELETE',uri.path, nil, headers)
  end
  
  
  # Do a get request to retrieve all the albums from a user using the user_id. 
  # The auth_token parameter is optional since it only retrieves more 
  # information about each album.
  
  def self.get_albums user_id, auth_token
    headers = {
      "Authorization" => "GoogleLogin auth=#{auth_token}",
      "Content-Type" => "application/atom+xml"
    }
    
    http = Net::HTTP.new(PICASA_HOST, 80)
    http.get(ALBUMS_PATH.gsub("$user_id$", user_id), headers)
  end
  
  # Do a get request to retrieve one specific album from a user
  
  def self.get_album user_id, album_id, auth_token
    headers = {
      "Authorization" => "GoogleLogin auth=#{auth_token}",
      "Content-Type" => "application/atom+xml"
    }
    
    path = SINGLE_ALBUM_PATH.gsub("$user_id$", user_id).gsub!("$album_id$", album_id)
    
    http = Net::HTTP.new(PICASA_HOST, 80)
    http.get path, headers
  end
  
  private 
  
  def self.update_album_xml xml, params
    doc = Nokogiri::XML xml
    doc.at_css('title').content = params[:title]
    doc.at_css('summary').content = params[:summary]
    doc.at_xpath('//gphoto:location').content = params[:location]
    doc.to_xml
  end
  
end
