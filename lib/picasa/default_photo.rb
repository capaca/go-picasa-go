module Picasa
  class DefaultPhoto
    acts_as_picasa_photo
    belongs_to_picasa_album :class_name => 'Picasa::DefaultAlbum'
  end
end
