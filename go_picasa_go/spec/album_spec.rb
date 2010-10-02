require 'spec_helper'

describe 'Picasa::Album' do
  
  before :each do
    delete_all_albums
  end
  
  class AlbumObject
    include Picasa::Album
    
    def user_id
      "bandmanagertest"
    end
    
    def password
      "$bandmanager$"
    end
  end
  
  it 'should save a new album' do
    album = AlbumObject.new
    album.title = "Album Title"
    album.summary = "Album Summary"
    album.location = "Album location"
    album.keywords = "Album keywords"
    
    album.p_save!
    album.p_save.should be_true
    
    album.instance_variables.each do |var_name|
      value = album.instance_variable_get var_name
      value.should_not be_nil
    end
  end
  
  it 'should not save a new album if cannot authenticate' do
    class AlbumObject
      def password
        "wrong_password"
      end
    end
    
    album = AlbumObject.new
    album.title = "Album Title"
    album.summary = "Album Summary"
    album.location = "Album location"
    album.keywords = "Album keywords"
    
    lambda { album.p_save! }.should raise_error
    album.p_save.should be_false
  end
  
  it 'should find an album by id' do
    auth_token = login
    album_id = post_album
    album = AlbumObject.find 'bandmanagertest', album_id, auth_token
    
    album.should_not be_nil
    album.id.should == album_id
  end
  
  it 'should get nil if album not found' do
    auth_token = login
    album = AlbumObject.find 'bandmanagertest', "0989", auth_token
    album.should be_nil
  end
  
  it 'should update an album' do
    album = create_album
    title1 = "Another title1"
    title2 = "Another title2"

    album.p_update! :title => title1
    album.title.should == title1

    album.p_update(:title => title2).should be_true
    album.title.should == title2
  end
  
  it 'should destroy an album' do
    album = create_album
    album.p_destroy
    
    auth_token = login
    AlbumObject.find('bandmanagertest', album.id, auth_token).should be_nil
  end
  
  private
  
  def create_album
    album = AlbumObject.new
    album.title = "Album Title"
    album.summary = "Album Summary"
    album.location = "Album location"
    album.keywords = "Album keywords"
    
    album.p_save!
    album
  end
end
