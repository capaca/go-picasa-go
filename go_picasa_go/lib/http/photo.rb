# Module that offers methods to do the basic HTTP requests to services provided
# by Picasa to manipulate photos.
module Picasa
  module HTTP
    module Photo
      
      # Do a get request to retrieve all the photos from an album
      
      def self.get_photos user_id, album_id
        uri = photos_uri user_id, album_id
        http = Net::HTTP.new(uri.host)
        http.get uri.path
      end
      
      # Do a post request to save a new photo.
      # It's necessary to inform the authentication token, the summary of the 
      # photo, and the file to be tranfered.
      
      def self.post_photo user_id, album_id, auth_token, summary, file
        uri = photos_uri user_id, album_id

        template = ERB.new File.open("lib/template/photo.erb").read
        body = template.result(binding)
        
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = body
        request["Content-Type"] = "multipart/related; boundary=\"END_OF_PART\""
        request["Authorization"] = "GoogleLogin auth=#{auth_token}"

        http.request(request)
      end
      
      private 
      
      def self.photos_uri user_id, album_id
        uri = URI.parse "http://picasaweb.google.com/data/feed/api/user/#{user_id}/albumid/#{album_id}"
      end
    end
  end
end
