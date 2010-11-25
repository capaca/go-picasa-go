require 'spec_helper'

describe 'Picasa::Album' do
  
  it 'should save a new album' do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_update_album :title => 'title'
    
    user = UserObject.new
    
    album = AlbumObject.new
    album.user = user
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
    mock_post_album_failure
    
    album = AlbumObject.new
    album.title = "Album Title"
    album.summary = "Album Summary"
    album.location = "Album location"
    album.keywords = "Album keywords"
    
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
    album.picasa_id.should == album_id
    
    album.user.should_not be_nil
    album.user.picasa_id.should_not be_nil
    album.user.picasa_id.should_not be_empty
    
    album.title.size.should > 0
    album.summary.size.should > 0
    album.location.size.should > 0
    album.access.size.should > 0
  end
  
  it 'should get nil if album is not found' do
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
    
    albums.each do |album|
      album.user.should_not be_nil
      album.user.picasa_id.should_not be_nil
      album.user.picasa_id.should_not be_empty
    end
  end
  
  it 'should update the title attribute from an album' do
    mock_authentication
    mock_post_album

    title1 = "Another title1"
    title2 = "Another title2"

    mock_update_album :title => title1, :access => 'private'
    
    album = create_album

    album.picasa_update_attributes! :title => title1, :access => 'private'
    album.title.should == title1
    album.access.should == 'private'

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
    AlbumObject.picasa_find('bandmanagertest', album.picasa_id, auth_token).should be_nil
    
    album = create_album
    album.picasa_destroy.should be_true
    
    auth_token = login
    AlbumObject.picasa_find('bandmanagertest', album.picasa_id, auth_token).should be_nil
    album = create_album
    album.picasa_destroy!
  end
  
  it 'should have the method user_class' do
    AlbumObject.user_class
    
    album = AlbumObject.new
    album.user_class
  end
  
  it 'should get all photos from an album' do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_post_photo
    mock_get_photos
    
    photo = create_photo
    
    album = photo.album
    photos = album.photos
    photos.should_not be_nil
    photos.size.should > 0
  end
  
  it 'should get one specific photo from an album' do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_post_photo
    mock_get_photo
    mock_download_image
    
    photo = create_photo
    
    album = photo.album
    photo2 = album.find_photo photo.picasa_id
    photo2.should_not be_nil
    photo2.picasa_id.should == photo.picasa_id
  end
  
  it 'should only uptade an album if it already exists when calling save method' do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_get_albums
    mock_post_photo
    mock_get_photo
    mock_update_album :title => 'Changing title'
    mock_download_image
    
    user = UserObject.new
    
    album = AlbumObject.new
    album.user = user
    album.title = "Album Title"
    
    album.picasa_save.should be_true
    num_albums = user.albums.size
    
    album.title = 'Changing title'
    album.picasa_save.should be_true
    
    user.albums(true).size.should == num_albums
    album2 = user.find_album album.picasa_id
  end
  
  it "should have the methods shortcuts" do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_get_albums
    mock_post_photo
    mock_get_photo
    mock_delete_album
    mock_update_album :title => 'Changing title'
    mock_download_image
    
    album = create_album
    
    album.save
    album.save!
    album.update
    album.update!
    album.update_attributes
    album.update_attributes!
    album.destroy
    album.destroy!
  end
  
end
