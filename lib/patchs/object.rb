class << Object

  # Class method that includes Picasa::User
  
  def acts_as_picasa_user
    include Picasa::User
  end
  
  # Class method that includes Picasa::Album
  
  def acts_as_picasa_album
    include Picasa::Album
  end
  
  # Class method that includes Picasa::Photo
  
  def acts_as_picasa_photo
    include Picasa::Photo
  end
  
end
