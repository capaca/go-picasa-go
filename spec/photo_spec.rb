require 'spec_helper'

describe "Picasa::Photo" do

  before do
    mock_authentication
    mock_post_album
    mock_post_photo
    mock_get_album
    mock_get_photo
    mock_get_photos
    mock_update_photo
    mock_delete_photo
    mock_download_image
  end

  it "should save a new photo in a album" do
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
    mock_update_photo :description => 'Photo summary updated'
    
    photo = create_photo
    
    photo.description = "Photo summary updated"
    photo.picasa_update!
    photo.description.should == "Photo summary updated" 
  end
  
  it "should destroy a photo" do
    photo = create_photo
    photo.destroy!
    
    photo = create_photo
    photo.destroy.should be_true
  end
  
  it "should raise exception if can not post photo" do
    mock_post_photo_failure
    
    album = create_album
    
    photo = PhotoObject.new
    photo.album = album
    photo.summary = "Photo summary"
    photo.file = nil
    
    lambda { photo.picasa_save! }.should raise_error
  end
    
  it "should retrieve the file when retrieving the photo" do
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
  
end













