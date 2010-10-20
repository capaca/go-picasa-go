# Default class already configured to be used with Picasa api.

module Picasa
  class DefaultAlbum
    acts_as_picasa_album
    belongs_to_picasa_user :class_name => "Picasa::DefaultUser"
    has_many_picasa_photos :class_name => 'Picasa::DefaultPhoto'
  end
end
