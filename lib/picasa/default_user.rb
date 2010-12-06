module Picasa
  class DefaultUser
    acts_as_picasa_user
    
    def album_class
      Picasa::DefaultAlbum
    end
    
    def self.album_class
      Picasa::DefaultAlbum
    end
  end
end
