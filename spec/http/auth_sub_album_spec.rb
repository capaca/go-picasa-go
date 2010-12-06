require 'spec_helper'

describe Picasa::AuthSubAlbum do

  before do
    mock_authentication
    mock_get_albums
    mock_get_album
    mock_post_album
    mock_update_album
    mock_delete_album

    
    sub_token = "1/lpcSMKlbwYy28vORo2yks0G1FQYclgBgHgH3ac8613Y"

    params = {
      :user_id => 'bandmanagertest',
      :sub_token => sub_token
    }

    @client = Picasa::AuthSubAlbum.new 'bandmanagertest', sub_token
    @client.should_not be_nil
    
    delete_all_albums
  end
  
  it 'should get albums from a client' do
    resp, body = @client.get_albums
    resp.code.should == "200"
    body.should_not be_empty
  end
  
  it 'should get an specific album from a client' do
    album_id = post_album
    
    resp, body = @client.get_album album_id
    resp.code.should == "200"
    body.should_not be_empty
  end
  
  it 'should post an album' do
    params = {
      :title => 'title',
      :summary => 'summary',
      :location => 'location',
      :access => 'public',
      :keywords => 'keywords' 
    }
    resp, body = @client.post_album params
    resp.code.should == "201"
    body.should_not be_empty
  end
  
  it 'should update an album' do
    album_id = post_album
    
    params = {
      :title => 'title_updated',
    }
    
    resp, body = @client.update_album album_id, params
    resp.code.should == "200"
    body.should_not be_empty
  end
  
  it 'should delete an album' do
    album_id = post_album
    
    resp, body = @client.delete_album album_id
    resp.code.should == "200"
    resp.message.should == "OK"    
  end 
 
end






















