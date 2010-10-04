module Picasa::Authentication
  include Picasa::Util

  # Authenticate user and returns the authorization token 
  # if the operation succedes. If the authorization cannot be acomplished
  # is raised an exception.
  
  def self.authenticate user_id, password
    resp, body = Picasa::HTTP::Authentication.authenticate user_id, password
    
    if resp.code != '200' or resp.message != 'OK'
      raise Exception, 'Could not authenticate user.'
    end
    
    extract_auth_token body
  end
end
