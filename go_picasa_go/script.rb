require 'rubygems'
require 'go_picasa_go'


class MeuUsuario
  act_as_picasa_user
  has_many_picasa_albums :class_name => "MeuAlbum"
  
  def user_id
    'bandmanagertest'
  end
  
  def auth_token
    'DQAAAHsAAAASi_ADDIYHfjjeN5S3zxA3CTyrljizPKcig62QAR5FvdZNLY6CgeHPl0R1LFQvE9z-DOni2gFHMNrHVObg1yY71DbzoVfZnJN9jGSsMTw4pVTLA9XKifzirGtrr2EUoFncGXVBIbDUromn7hK3Bb14Kp--HzGcQj4pg1hXZch3Gg'
  end
end

class MeuAlbum
  act_as_picasa_album
  belongs_to_picasa_user :class_name => "MeuUsuario"
end

class MinhaPhoto
  act_as_picasa_photo
  belongs_to_picasa_album :class_name => "MeuAlbum"
end

@user = MeuUsuario.new
@album = MeuAlbum.new
@album.user = @user

@photo = MinhaPhoto.new
@photo.album = @album
