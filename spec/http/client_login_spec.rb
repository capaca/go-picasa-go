require 'spec_helper'

describe Picasa::ClientLogin do

  before do
    mock_authentication
    mock_get_albums
    mock_get_album
    mock_post_album
    mock_update_album
    mock_delete_album
    
    auth_key = "DQAAAH4AAAAbp4dgMJHRpOk8O5H-RME41nOzHtdrWt5TX1bHXvZ8KrWzHrBu7sqr"+
    "hPzDN-CtIQxk0A1xbACAtnKk2EYKuCeLzqx17UH23-o9bCqq3LamPVgHbI59tYp53m1VfnAH9"+
    "8hZyuN5HaQOuaAnOKzmUMJW-VVjQ8B8v8SBtDjy378FmQ"

    params = {
      :user_id => 'bandmanagertest',
      :auth_key => auth_key
    }
    
    @client = Picasa::ClientLogin.new 'bandmanagertest', auth_key
    @client.should_not be_nil
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






















