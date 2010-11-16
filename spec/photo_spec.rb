require 'spec_helper'

describe "Picasa::Photo" do

  it "should save a new photo in a album" do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_post_photo
    mock_update_photo 
    
    album = create_album
    file = File.open 'spec/fixture/photo.jpg'
    
    photo = PhotoObject.new
    photo.album = album
    photo.summary = "Photo summary"
    photo.file = file
    
    photo.picasa_save!
    photo.picasa_save.should be_true
    
    photo.instance_variables.each do |var_name|
      value = photo.instance_variable_get var_name
      value.should_not be_nil
    end
  end
  
  it "should update a photo" do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_post_photo
    mock_update_photo :description => 'Photo summary updated'
    
    photo = create_photo
    
    photo.description = "Photo summary updated"
    photo.picasa_update!
    photo.description.should == "Photo summary updated" 
  end
  
  it "should destroy a photo" do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_post_photo
    mock_delete_photo
    
    photo = create_photo
    photo.destroy!
    
    photo = create_photo
    photo.destroy.should be_true
  end
  
  it "should raise exception if can not post photo" do
    mock_authentication
    mock_post_album
    mock_get_album
    mock_get_albums
    mock_post_photo_failure
    
    album = create_album
    
    photo = PhotoObject.new
    photo.album = album
    photo.summary = "Photo summary"
    photo.file = nil
    
    lambda { photo.picasa_save! }.should raise_error
  end
  
  it "should find all photos from an album" do
    mock_authentication
    mock_post_album
    mock_post_photo
    mock_get_album
    mock_get_photos
    
    photo = create_photo
    
    photos = PhotoObject.picasa_find_all photo.album.user.picasa_id, 
      photo.album.picasa_id, photo.album.user.auth_token
    
    photos.should_not be_nil
    photos.each do |p|
      p.album.picasa_id.should == photo.album.picasa_id
    end
  end
  
  it "should find a photo" do
    mock_authentication
    mock_post_album
    mock_post_photo
    mock_get_album
    mock_get_photo
    mock_download_image
    
    photo1 = create_photo
    user_id = photo1.album.user.picasa_id
    album_id = photo1.album.picasa_id
    photo_id = photo1.picasa_id
    auth_token = photo1.album.user.auth_token
    
    photo2 = PhotoObject.picasa_find user_id, album_id, photo_id, auth_token
    
    photo2.picasa_id.should == photo1.picasa_id
    photo2.album.should_not be_nil
  end
  
  it "should retrieve the file when retrieving the photo" do
    mock_authentication
    mock_post_album
    mock_post_photo
    mock_get_album
    mock_get_photo
    mock_update_photo
    mock_download_image
    
    photo1 = create_photo
    album = photo1.album
    photo2 = album.find_photo photo1.picasa_id
    photo2.file.should_not be_nil
    photo2.file.path
    File.exists?(photo2.file.path).should be_true
  end
  
  it "should have the album class" do
    PhotoObject.album_class
    photo = PhotoObject.new
    photo.album_class
  end
  
  it "should only uptade photo if it already exists when calling save method" do
    mock_authentication
    mock_post_album
    mock_post_photo
    mock_get_album
    mock_get_photo
    mock_get_photos
    mock_update_photo
    mock_download_image
    
    album = create_album
    file = File.open 'spec/fixture/photo.jpg'
    
    photo = PhotoObject.new
    photo.album = album
    photo.summary = "Photo summary"
    photo.file = file
    
    photo.picasa_save.should be_true
    
    album = photo.album        
    num_photos = album.photos.size
    
    photo2 = album.find_photo photo.picasa_id
    photo2.summary = 'changing summary'
    photo2.picasa_save.should be_true
    
    album.photos(true).size.should == num_photos.should
  end
  
  it "should only uptade photo if it already exists when calling save method" do
    mock_authentication
    mock_post_album
    mock_post_photo
    mock_get_album
    mock_get_photo
    mock_get_photos
    mock_update_photo
    mock_delete_photo
    mock_download_image
    
    photo = create_photo

    photo.save
    photo.save!
    photo.update
    photo.update!
    photo.update_attributes
    photo.update_attributes!
    photo.destroy
    photo.destroy!
  end
  
end













