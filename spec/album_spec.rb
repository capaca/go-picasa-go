require 'spec_helper'

describe 'Picasa::Album' do
  
  before :all do
    @session = AlbumObject.auth_sub_session 'bandmanagertest', "1/lpcSMKlbwYy28vORo2yks0G1FQYclgBgHgH3ac8613Y"
  end
  
  before do
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
  
  it 'should save a new album' do
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
  
  it 'should get nil if album is not found' do
    mock_get_album_failure
    
    auth_token = login
    album = @session.find_album "8668"
    album.should be_nil
  end
  
  it 'should find all albums from an user' do
    auth_token = login
    post_album # Create one album
    albums = @session.albums
    albums.should_not be_nil
    albums.size.should > 0
  end
  
  it 'should update the title attribute from an album' do
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
    mock_get_album_failure
    
    album = create_album
    album.picasa_destroy
    
    auth_token = login
    @session.find_album(album.picasa_id).should be_nil
    
    album = create_album
    album.picasa_destroy.should be_true
    
    auth_token = login
    @session.find_album(album.picasa_id).should be_nil
    album = create_album
    album.picasa_destroy!
  end
    
  it 'should get all photos from an album' do
    mock_post_photo
    mock_get_photos
    
    photo = create_photo
    
    album = photo.album
    photos = album.photos
    photos.should_not be_nil
    photos.size.should > 0
  end
  
  it 'should get one specific photo from an album' do
    photo = create_photo
    
    album = photo.album
    photo2 = album.find_photo photo.picasa_id
    photo2.should_not be_nil
    photo2.picasa_id.should == photo.picasa_id
  end
  
  it 'should only uptade an album if it already exists when calling save method' do
    album = AlbumObject.new
    album.title = "Album Title"
    
    album.picasa_save.should be_true
    
    album.title = 'Changing title'
    album.picasa_save.should be_true
  end
  
  it "should have the methods shortcuts" do
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
