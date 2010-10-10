# Module that offers methods to do high level operations concerning
# a google user within Picasa.

module Picasa::User

  # Class methods that will be included in the class that include this module.

  module ClassMethods
    
    # Method used to tell the gem what is the class that implementes the
    # Picasa::Album module.
    
    def has_many_picasa_albums params
      unless params[:class_name] and params[:class_name].class == String
        raise Exception, 'You should pass the string of the class name that includes Picasa::Album.'
      end

      define_dependent_class_methods :album_class, params[:class_name]      
    end
  end

  def self.included(base)
    ClassMethods.extend Picasa::Util
    base.extend(ClassMethods)
  end
  
  attr_accessor :user_id, :auth_token
  attr_writer :password
  
  # Authenticates user using the attributes of the instance.
  # Returns the authentication token if the authentication succedes, otherwise
  # an exception is raised.
  
  def authenticate
    @auth_token ||= Picasa::Authentication.authenticate user_id, @password
  end
  
  # Find an album from the current user using the album_id
  
  def find_album album_id
    album = album_class.picasa_find user_id, album_id, auth_token
    album
  end
  
  # Find all albums from the current user
  
  def find_all_albums
    albums = album_class.picasa_find_all user_id, auth_token
    albums
  end
end
