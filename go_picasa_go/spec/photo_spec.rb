require 'spec_helper'

describe "Picasa::Photo" do

  before :each do
    delete_all_albums
  end
  
  it "should have the album class" do
    photo = PhotoObject.new
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
    photo = create_photo
    
    photo.summary = "Photo summary updated"
    photo.picasa_update!
    photo.summary.should == "Photo summary updated" 
  end
  
  it "should destroy a photo" do
    photo = create_photo
    photo.destroy!
    
    photo = create_photo
    photo.destroy.should be_true
  end
  
  it "should raise exception if can not post photo" do
    album = create_album
    
    photo = PhotoObject.new
    photo.album = album
    photo.summary = "Photo summary"
    photo.file = nil
    
    lambda { photo.picasa_save! }.should raise_error
  end
  
end
