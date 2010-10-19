require 'rubygems'
require 'go_picasa_go'


class MeuUsuario
  acts_as_picasa_user
  has_many_picasa_albums :class_name => "MeuAlbum"
  
  def picasa_id
    'bandmanagertest'
  end
  
  def auth_token
    "DQAAAHsAAAAdMyvdNfPg_iTFD-T_u6bBb-9BegOP7CGWnjah7FCJvnu8aiOoHXJMAJ-6HS_8vOE"+
    "2zFLXaSzp3oe4mB9lJexTpxxM-CmChSTs-9OBd6nAwNji5yWnLUFv_Q7-ibXMx7820aFdnU7mr6"+
    "qqvHUhXESdhBEnD1QP_o8dqsP-6T-oig"
  end

end

class MeuAlbum
  acts_as_picasa_album
  belongs_to_picasa_user :class_name => "MeuUsuario"
end

class MinhaPhoto
  acts_as_picasa_photo
  belongs_to_picasa_album :class_name => "MeuAlbum"
end

@user = MeuUsuario.new

@album = MeuAlbum.new
@album.user = @user
@album.title = 'title'
@album.summary = 'summary'
@album.location = 'location'
@album.keywords = 'keywords'
@album.access = 'public'
@album.picasa_save!

@photo = MinhaPhoto.new
@photo.album = @album
@photo.summary = 'summary'
@photo.file = File.open 'spec/fixture/photo.jpg', 'r'
@photo.picasa_save!
