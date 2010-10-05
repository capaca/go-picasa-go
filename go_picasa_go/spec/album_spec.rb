require 'spec_helper'

describe 'Picasa::Album' do
  
  it 'should save a new album' do
    mock_authentication
    mock_post_album
    
    album = AlbumObject.new
    album.title = "Album Title"
    album.summary = "Album Summary"
    album.location = "Album location"
    album.keywords = "Album keywords"
    
    album.picasa_save!
    album.picasa_save.should be_true
    
    album.instance_variables.each do |var_name|
      value = album.instance_variable_get var_name
      value.should_not be_nil
    end
  end
  
  it 'should not save a new album if cannot authenticate' do
    mock_authentication_failure
    
    album = AlbumObject.new
    album.title = "Album Title"
    album.summary = "Album Summary"
    album.location = "Album location"
    album.keywords = "Album keywords"
    
    album.stub!(:auth_token).and_return("invalid_token")
    
    lambda { album.picasa_save! }.should raise_error
    album.picasa_save.should be_false
  end
  
  it 'should find an album by id' do
    mock_authentication
    mock_post_album
    mock_get_album
    
    auth_token = login
    album_id = post_album
    album = AlbumObject.picasa_find 'bandmanagertest', album_id, auth_token
    
    album.should_not be_nil
    album.id.should == album_id
  end
  
  it 'should get nil if album not found' do
    mock_authentication
    mock_get_album_failure
    
    auth_token = login
    album = AlbumObject.picasa_find 'bandmanagertest', "0989", auth_token
    album.should be_nil
  end
  
  it 'should find all albums from an user' do
    mock_authentication
    mock_post_album
    mock_get_albums

    auth_token = login
    post_album # Create one album
    albums = AlbumObject.picasa_find_all 'bandmanagertest', auth_token
    albums.should_not be_nil
    albums.size.should > 0
  end
  
  it 'should update the title attribute from an album' do
    mock_authentication
    mock_post_album

    title1 = "Another title1"
    title2 = "Another title2"

    mock_update_album :title => title1
    
    album = create_album

    album.picasa_update_attributes! :title => title1
    album.title.should == title1

    mock_update_album :title => title2

    album.picasa_update_attributes(:title => title2).should be_true
    album.title.should == title2
  end
  
  it 'should update an album' do
    mock_authentication
    mock_post_album

    title1 = "Another title1"
    title2 = "Another title2"

    mock_update_album :title => title1
    
    album = create_album
    album.title = title1
    
    album.picasa_update!
    album.title.should == title1

    mock_update_album :title => title2
    
    album.title = title2

    album.picasa_update.should be_true
    album.title.should == title2
  end
  
  it 'should destroy an album' do
    mock_authentication
    mock_post_album
    mock_delete_album
    mock_get_album_failure
    
    album = create_album
    album.picasa_destroy
    
    auth_token = login
    AlbumObject.picasa_find('bandmanagertest', album.id, auth_token).should be_nil
    
    album = create_album
    album.picasa_destroy.should be_true
    
    auth_token = login
    AlbumObject.picasa_find('bandmanagertest', album.id, auth_token).should be_nil
    album = create_album
    album.picasa_destroy!
  end
  
end
