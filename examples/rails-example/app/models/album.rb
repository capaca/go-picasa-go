class Album
  acts_as_picasa_album
  belongs_to_picasa_user :class_name => 'User'
end
