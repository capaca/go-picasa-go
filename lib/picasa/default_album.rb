# Default class already configured to be used with Picasa api.

module Picasa
  class DefaultAlbum
    acts_as_picasa_album
    
    def self.photo_class
      Picasa::DefaultPhoto
    end
    
    def photo_class
      self.class.photo_class
    end

  end
end
