# Module that offers methods to do the basic HTTP requests to authenticate
# an user with a google account.

module Picasa::Authentication
  extend Picasa::Util

  # Authenticate user and returns the authorization token 
  # if the operation succeeds other whise an exception is raised.
  
  def self.authenticate user_id, password
    resp, body = Picasa::HTTP::Authentication.authenticate user_id, password
    
    if resp.code != '200' or resp.message != 'OK'
      raise Exception, "Could not authenticate user. Code: #{resp.code}. Message: #{resp.message}"
    end
    
    extract_auth_token body
  end
  
  def self.upgrade_token token
    resp, body = Picasa::HTTP::Authentication.upgrade_token token
    
    if resp.code != '200' or resp.message != 'OK'
      raise Exception, "Could not upgrade token. Code: #{resp.code}. Message: #{resp.message}"
    end
    
    extract_auth_sub_token body
  end
end
