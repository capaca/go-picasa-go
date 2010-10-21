class Photo
  acts_as_picasa_photo
  belongs_to_picasa_album :class_name => 'Album'
end
