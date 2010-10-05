require 'spec_helper'

describe 'Picasa::User' do

  it 'should raise exception when missconfigurate the class that includes User module' do
    lambda {
      class UserObject
        act_as_picasa_user
        
        # The class_name param should be String not class
        has_many_picasa_albums :class_name => String.class
      end
    }.should raise_exception
  end

  it 'should authenticate an user and set the auth_token attribute' do
    mock_authentication
    
    user = UserObject.new
    user.user_id = "bandmanagertest"
    user.password = "$bandmanager$"
    auth_token = user.authenticate
    
    auth_token.should_not be_nil
    auth_token.should_not be_empty
    
    user.auth_token.should == auth_token
  end
  
  it 'should find all albums from a user' do
    mock_authentication
    mock_post_album
    mock_get_albums
    
    user = UserObject.new
    user.user_id = 'bandmanagertest'
    user.password = "$bandmanager$"
    user.authenticate.should_not be_nil
    
    album1 = create_album
    
    albums = user.find_all_albums
    albums.should_not be_nil
    albums.size.should > 0
    
    albums.each do |album|
      album.user.user_id.should == user.user_id
    end
  end
  
  it 'should find an album from a user' do
    mock_post_album
    mock_get_album
    
    user = UserObject.new
    user.user_id = 'bandmanagertest'
    user.auth_token = 'DQAAAHsAAAASi_ADDIYHfjjeN5S3zxA3CTyrljizPKcig62QAR5FvdZNL'+
      'Y6CgeHPl0R1LFQvE9z-DOni2gFHMNrHVObg1yY71DbzoVfZnJN9jGSsMTw4pVTLA9XKifzirG'+
      'trr2EUoFncGXVBIbDUromn7hK3Bb14Kp--HzGcQj4pg1hXZch3Gg'
    
    album1 = create_album
    
    album2 = user.find_album album1.id
    album2.should_not be_nil
    album2.id.should == album1.id
  end
  
  it 'should have the album_class method' do
    UserObject.album_class
    
    user = UserObject.new
    user.album_class
  end

end
