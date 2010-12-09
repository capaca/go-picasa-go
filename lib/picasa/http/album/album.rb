# Module that offers methods to do the basic HTTP requests to services provided
# by Picasa to manipulate albums.
module Picasa
  module HTTP
    module Album
      # Do a post request to create an album into the user account. 
      # The attributes used to create the album are:
      #
      # title, summary, location, keywords

      def self.post_album user_id, params, headers
        
        headers = albums_headers headers
        
        uri = albums_uri user_id
        http = Net::HTTP.new(uri.host, uri.port)
        
        # Render the album template
        template_path = File.dirname(__FILE__) + '/../../template/'
        template = ERB.new File.open(template_path+"album.xml.erb").read
        
        data = template.result(binding)
        
        return http.post(uri.path, data, headers)
      end
      
      # Do a put request to update album data
      
      def self.update_album user_id, album_id, params, headers
        headers["If-Match"] = "*"
        headers = albums_headers headers

        resp, data = get_album user_id, album_id, headers
        
        raise Exception, "Album not found." unless resp.code == "200"

        data = update_album_xml data, params 
        
        uri = album_uri user_id, album_id
        http = Net::HTTP.new(uri.host, uri.port)
        http.send_request('PUT',uri.path, data, headers)
      end
      
      # Do a delete request to delete an album from a user
      
      def self.delete_album user_id, album_id, headers
        headers["If-Match"] = "*"
        headers = albums_headers headers
        
        uri = album_uri user_id, album_id
        http = Net::HTTP.new(uri.host, uri.port)
        http.send_request('DELETE',uri.path, nil, headers)
      end
      
      # Do a get request to retrieve all the albums from a user using the user_id. 

      def self.get_albums user_id, headers
        headers = albums_headers headers
        
        uri = albums_uri user_id
        
        http = Net::HTTP.new(uri.host, 80)
        http.get uri.path, headers
      end
      
      # Do a get request to retrieve one specific album from a user
      
      def self.get_album user_id, album_id, headers
        headers = albums_headers headers
        
        uri = album_uri user_id, album_id
        
        http = Net::HTTP.new(uri.host, 80)
        http.get uri.path, headers
      end
      
      private 
      
      def self.update_album_xml xml, params
        doc = Nokogiri::XML xml
        doc.at_css('title').content = params[:title] if params[:title]
        doc.at_css('summary').content = params[:summary] if params[:summary]
        doc.at_xpath('//gphoto:access').content = params[:access] if params[:access]
        doc.at_xpath('//gphoto:location').content = params[:location] if params[:location]
        doc.at_xpath('//media:keywords').set_attribute("value", params[:keywords]) if params[:keywords]
        doc.to_xml
      end
      
      def self.albums_headers opts = {}
        headers = {}
        headers["Content-Type"] = "application/atom+xml"
        headers.merge opts
      end
      
      def self.albums_uri user_id
        URI.parse "http://picasaweb.google.com/data/feed/api/user/#{user_id}"
      end
      
      def self.album_uri user_id, album_id
        URI.parse "http://picasaweb.google.com/data/entry/api/user/#{user_id}/albumid/#{album_id}"
      end
    end
  end
end
