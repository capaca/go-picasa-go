# Module that offers methods to do the basic HTTP requests to services provided
# by Picasa to manipulate photos.
module Picasa
  module HTTP
    module Photo
      
      # Do a get request to retrieve all the photos from an album
      
      def self.get_photos user_id, album_id, auth_token
        uri = photos_uri user_id, album_id
        http = Net::HTTP.new(uri.host)
        http.get uri.path, auth_header(auth_token)
      end
      
      # Do a get request to retrieve one photo from an album
      
      def self.get_photo user_id, album_id, photo_id, auth_token
        uri = photo_uri user_id, album_id, photo_id
        http = Net::HTTP.new(uri.host)
        http.get uri.path, auth_header(auth_token)
      end
      
      # Do a post request to save a new photo.
      
      def self.post_photo user_id, album_id, auth_token, summary, file
        uri = photos_uri user_id, album_id

        template_path = File.dirname(__FILE__) + '/../template/'
  
        template = ERB.new File.open(template_path+"photo.erb").read
        body = template.result(binding)
        
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = body
        request["Content-Type"] = "multipart/related; boundary=\"END_OF_PART\""
        request["Authorization"] = "GoogleLogin auth=#{auth_token}"

        http.request(request)
      end
      
      # Do a delete request to delete a photo from an album
      
      def self.delete_photo user_id, album_id, photo_id, auth_token
        uri = photo_uri user_id, album_id, photo_id
        headers = photos_headers auth_token, "If-Match" => "*"
        
        http = Net::HTTP.new(uri.host, uri.port)
        http.send_request('DELETE',uri.path, nil, headers)
      end
      
      # Do a put request to update a photo from an album
      
      def self.update_photo user_id, album_id, photo_id, auth_token, summary, file
        uri = photo_media_uri user_id, album_id, photo_id
        
        template_path = File.dirname(__FILE__) + '/../template/'
  
        template = ERB.new File.open(template_path+"photo.erb").read
        body = template.result(binding)
        
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Put.new(uri.request_uri)
        request.body = body
        request["Content-Type"] = "multipart/related; boundary=\"END_OF_PART\""
        request["Authorization"] = "GoogleLogin auth=#{auth_token}"
        request["If-Match"] = "*"

        http.request(request)
      end 
      
      def self.download_image link
        uri = URI.parse link
        
        file_name = link.split("/").last
        
        http = Net::HTTP.new(uri.host)
        resp = http.get uri.path
        
        tempfilename = File.join(Dir.tmpdir, file_name)
        tempfile = File.new(tempfilename, "w")
        tempfile.write resp.body
        tempfile.close
        tempfile
      end
      
      private 
      
      def self.photos_uri user_id, album_id
        URI.parse "http://picasaweb.google.com/data/feed/api/user/#{user_id}/albumid/#{album_id}"
      end
      
      def self.photo_uri user_id, album_id, photo_id
        URI.parse "http://picasaweb.google.com/data/entry/api/user/#{user_id}/albumid/#{album_id}/photoid/#{photo_id}"
      end
      
      def self.photo_media_uri user_id, album_id, photo_id
        URI.parse "http://picasaweb.google.com/data/media/api/user/#{user_id}/albumid/#{album_id}/photoid/#{photo_id}"
      end
      
      def self.auth_header auth_token
        headers = {
          "Authorization" => "GoogleLogin auth=#{auth_token}"
        }
      end
      
      def self.photos_headers auth_token, opts = {}
        headers = {
          "Authorization" => "GoogleLogin auth=#{auth_token}",
          "Content-Type" => "application/atom+xml"
        }
        
        headers.merge opts
      end
    end
  end
end
