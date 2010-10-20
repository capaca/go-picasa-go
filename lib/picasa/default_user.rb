module Picasa
  class DefaultUser
    acts_as_picasa_user
    has_many_picasa_albums :class_name => "Picasa::DefaultAlbum"
  end
end
