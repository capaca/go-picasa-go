module Picasa
  class DefaultPhoto
    acts_as_picasa_photo
    
    def self.album_class
      Picasa::DefaultAlbum
    end
  end
end
