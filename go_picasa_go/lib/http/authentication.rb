# Module that offers methods to do the basic HTTP requests to authenticate user
# for Picasa.

module Picasa
  module HTTP
    module Authentication
      
      HTTPS_PORT = 443
      
      PICASA_SERVICE = 'lh2'
      APP_NAME = 'BandManager'
      
      # Do a post request to authenticate user with the e-mail and password provided
      # and return the response and data of the request
      
      def self.authenticate email, password
        uri = uri_login
        
        http = Net::HTTP.new(uri.host, HTTPS_PORT)
        http.use_ssl=true

        data = login_data email, password
        
        headers = {'Content-Type' => 'application/x-www-form-urlencoded'}
        resp, data = http.post(uri.path, data, headers)
      end
      
      private 
        
      def self.login_data email, password
        "accountType=HOSTED_OR_GOOGLE&Email=#{email}&Passwd=#{password}&service=#{PICASA_SERVICE}&source=#{APP_NAME}"
      end
      
      def self.uri_login
        URI.parse "http://www.google.com/accounts/ClientLogin"
      end  
    end
  end
end

