require 'spec_helper'

describe Picasa::ClientLogin do

  before do
#    mock_authentication
#    mock_get_albums
#    mock_get_album
#    mock_post_album
#    mock_update_album
#    mock_delete_album
    
#    delete_all_albums
    
    auth_key = login
    
#    "DQAAAH4AAAAbp4dgMJHRpOk8O5H-RME41nOzHtdrWt5TX1bHXvZ8KrWzHrBu7sqr"+
#    "hPzDN-CtIQxk0A1xbACAtnKk2EYKuCeLzqx17UH23-o9bCqq3LamPVgHbI59tYp53m1VfnAH9"+
#    "8hZyuN5HaQOuaAnOKzmUMJW-VVjQ8B8v8SBtDjy378FmQ"

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

    it 'should get all from an album' do
      album_id = post_album
      
      resp, body = @client.get_photos album_id
      resp.code.should == "200"
      body.should_not be_empty
    end
    
    it 'should get one specific photo from album' do
      album_id, photo_id = post_photo

      resp, body = @client.get_photo album_id, photo_id
      resp.code.should == "200"
      body.should_not be_empty
    end
    
    it 'should post a photo in an album' do
      album_id = post_album

      file = File.open 'spec/fixture/photo.jpg'

      resp, body = @client.post_photo album_id, "Summary", file
      resp.code.should == "201"
      body.should_not be_empty
    end
    
    it 'should update a photo' do
      album_id, photo_id = post_photo

      file = File.open 'spec/fixture/photo.jpg'

      resp, body = @client.update_photo album_id, photo_id, "changed", file
      resp.code.should == "200"
      body.should_not be_empty
    end
    
    it 'should delete a photo' do
      album_id, photo_id = post_photo

      resp, body = @client.delete_photo album_id, photo_id
      resp.code.should == "200"
      
      resp, body = @client.get_photo album_id, photo_id
      resp.code.should == "404"
    end
    
  end

end






















