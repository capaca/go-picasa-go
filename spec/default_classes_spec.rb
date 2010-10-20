require 'spec_helper'

describe 'Picasa::Album' do
  
  class MyUser < Picasa::DefaultUser
    def picasa_id
      "bandmanagertest"
    end
    
    def auth_token
      "DQAAAHsAAAAdMyvdNfPg_iTFD-T_u6bBb-9BegOP7CGWnjah7FCJvnu8aiOoHXJMAJ-6HS_8vOE"+
      "2zFLXaSzp3oe4mB9lJexTpxxM-CmChSTs-9OBd6nAwNji5yWnLUFv_Q7-ibXMx7820aFdnU7mr6"+
      "qqvHUhXESdhBEnD1QP_o8dqsP-6T-oig"
    end
  end
  
  
  it 'should be able to instantiate an user and start using go picasa go' do
    mock_authentication
    mock_post_album
    mock_get_albums
    mock_get_album
    mock_post_photo
    mock_get_photos
    mock_get_photo
    
    user = MyUser.new
    user.album_class.should == Picasa::DefaultAlbum
    
    album = Picasa::DefaultAlbum.new
    album.title = 'Title'
    album.user = user
    album.picasa_save.should be_true
    
    photo = Picasa::DefaultPhoto.new
    photo.summary = 'summary'
    photo.file = File.open 'spec/fixture/photo.jpg', 'r'
    photo.album = album
    photo.picasa_save.should be_true
    
    albums = user.albums
    albums.should_not be_nil
    albums.size.should > 0
    
    photos = albums.first.photos
    photos.should_not be_nil
    photos.size.should > 0
  end

end
