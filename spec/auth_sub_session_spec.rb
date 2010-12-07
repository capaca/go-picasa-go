require 'spec_helper'

describe 'Picasa::Album' do
  
  before do
    @session = AlbumObject.auth_sub_session 'bandmanagertest', "1/lpcSMKlbwYy28vORo2yks0G1FQYclgBgHgH3ac8613Y"
    
    mock_authentication
    mock_post_album
    mock_get_album
    mock_get_albums
    mock_post_photo
    mock_get_photo
    mock_delete_album
    mock_update_album :title => 'Changing title'
    mock_download_image
  end
    
  #FIXME Move to Session test class
  it 'should find an album by id' do
    auth_token = login
    album_id = post_album
    album = @session.find_album album_id
    
    album.should_not be_nil
    album.picasa_id.should == album_id
        
    album.title.size.should > 0
    album.summary.size.should > 0
    album.location.size.should > 0
    album.access.size.should > 0
  end
  
  #FIXME Move to Session test class
  it 'should get nil if album is not found' do
    mock_get_album_failure
    
    auth_token = login
    album = @session.find_album "8668"
    album.should be_nil
  end
  
end
