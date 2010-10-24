# Class used to generate the authentication token

class AuthenticationTokenGenerator
  include Singleton
  
  # Generates the authentication token based 
  # on the picasa id and the password informed.
  
  def generate picasa_id, password
    Picasa::Authentication.authenticate picasa_id, password
  end
end
