require 'spec_helper'

describe Picasa::ClientLogin do

  before do
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
    
    auth_key = login

    params = {
      :user_id => 'bandmanagertest',
      :auth_key => auth_key
    }
    
    @client = Picasa::ClientLogin.new 'bandmanagertest', auth_key
    @client.should_not be_nil
  end
  
  context "when dealing with albums" do

    it 'should get all from a client' do
      resp, body = @client.get_albums
      resp.code.should == "200"
      body.should_not be_empty
    end
    
    it 'should get one specific from a client' do
      album_id = post_album
      
      resp, body = @client.get_album album_id
      resp.code.should == "200"
      body.should_not be_empty
    end
    
    it 'should post' do
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
    
    it 'should update' do
      album_id = post_album
      
      params = {
        :title => 'title_updated',
      }
      
      resp, body = @client.update_album album_id, params
      resp.code.should == "200"
      body.should_not be_empty
    end
    
    it 'should delete' do
      album_id = post_album
      
      resp, body = @client.delete_album album_id
      resp.code.should == "200"
      resp.message.should == "OK"    
    end
  
  end
  
  context 'when dealing with photos' do

 
    
  end

end






















