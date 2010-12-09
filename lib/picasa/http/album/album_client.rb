module Picasa::HTTP::AlbumClient
  
  def get_albums
    headers = albums_headers auth_header
        
    uri = albums_uri @user_id
    
    http = Net::HTTP.new(uri.host, 80)
    http.get uri.path, headers
  end
  
  def get_album album_id
    headers = albums_headers auth_header
    
    uri = album_uri @user_id, album_id
    
    http = Net::HTTP.new(uri.host, 80)
    http.get uri.path, headers
  end
  
  def post_album params
    headers = albums_headers auth_header
        
    uri = albums_uri @user_id
    http = Net::HTTP.new(uri.host, uri.port)
    
    # Render the album template
    template_path = File.dirname(__FILE__) + '/../../template/'
    template = ERB.new File.open(template_path+"album.xml.erb").read
    
    data = template.result(binding)
    
    http.post(uri.path, data, headers)
  end
  
  def update_album album_id, params
    headers = auth_header
    headers["If-Match"] = "*"
    headers = albums_headers headers

    resp, data = self.get_album album_id
    
    raise Exception, "Album not found." unless resp.code == "200"

    data = update_album_xml data, params 
    
    uri = album_uri @user_id, album_id
    http = Net::HTTP.new(uri.host, uri.port)
    http.send_request('PUT',uri.path, data, headers)
  end
  
  def delete_album album_id
    headers = auth_header
    headers["If-Match"] = "*"
    headers = albums_headers headers
    
    uri = album_uri @user_id, album_id
    http = Net::HTTP.new(uri.host, uri.port)
    http.send_request('DELETE',uri.path, nil, headers)
  end
  
  protected 
  
  def update_album_xml xml, params
    doc = Nokogiri::XML xml
    doc.at_css('title').content = params[:title] if params[:title]
    doc.at_css('summary').content = params[:summary] if params[:summary]
    doc.at_xpath('//gphoto:access').content = params[:access] if params[:access]
    doc.at_xpath('//gphoto:location').content = params[:location] if params[:location]
    doc.at_xpath('//media:keywords').set_attribute("value", params[:keywords]) if params[:keywords]
    doc.to_xml
  end
  
  def albums_headers opts = {}
    headers = {}
    headers["Content-Type"] = "application/atom+xml"
    headers.merge opts
  end
  
  def albums_uri user_id
    URI.parse "http://picasaweb.google.com/data/feed/api/user/#{user_id}"
  end
  
  def album_uri user_id, album_id
    URI.parse "http://picasaweb.google.com/data/entry/api/user/#{user_id}/albumid/#{album_id}"
  end
end


