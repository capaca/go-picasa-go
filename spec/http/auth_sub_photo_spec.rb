require 'spec_helper'

describe Picasa::AuthSubPhoto do

  before :all do
    mock_authentication
    mock_get_albums
    mock_get_album
    mock_post_album
    mock_update_album
    mock_delete_album
    mock_get_photos
    mock_get_photo
    mock_post_photo
    mock_update_photo
    mock_delete_photo

    delete_all_albums

    @album_id, @photo_id = post_photo
    
    sub_token = "1/lpcSMKlbwYy28vORo2yks0G1FQYclgBgHgH3ac8613Y"

    params = {
      :user_id => 'bandmanagertest',
      :sub_token => sub_token
    }

    @client = Picasa::AuthSubPhoto.new 'bandmanagertest', @album_id, sub_token
    @client.should_not be_nil
    
  end

  it 'should get all photos from an album' do
    resp, body = @client.get_photos
    resp.code.should == "200"
    body.should_not be_empty
  end

  it 'should get one specific photo from album' do
    resp, body = @client.get_photo @photo_id
    resp.code.should == "200"
    body.should_not be_empty
  end

  it 'should post a photo in an album' do
    file = File.open 'spec/fixture/photo.jpg'

    resp, body = @client.post_photo "Summary", file
    resp.code.should == "201"
    body.should_not be_empty
  end

  it 'should update a photo' do
    file = File.open 'spec/fixture/photo.jpg'

    resp, body = @client.update_photo @photo_id, "changed", file
    resp.code.should == "200"
    body.should_not be_empty
  end

  it 'should delete a photo' do
    resp, body = @client.delete_photo @photo_id
    resp.code.should == "200"
  end

end
