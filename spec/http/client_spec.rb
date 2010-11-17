require 'spec_helper'

describe Picasa::HTTP::Client do

  before do
    auth_key = "DQAAAH4AAAAbp4dgMJHRpOk8O5H-RME41nOzHtdrWt5TX1bHXvZ8KrWzHrBu7sqr"+
      "hPzDN-CtIQxk0A1xbACAtnKk2EYKuCeLzqx17UH23-o9bCqq3LamPVgHbI59tYp53m1VfnAH9"+
      "8hZyuN5HaQOuaAnOKzmUMJW-VVjQ8B8v8SBtDjy378FmQ"

    params = {
      :user_id => 'bandmanagertest',
      :auth_key => auth_key
    }
    
    @client = Picasa::HTTP::Client.new params
    @client.should_not be_nil
    
    delete_all_albums
  end

  it 'should initialize a client' do
    
    auth_key = "DQAAAH4AAAAbp4dgMJHRpOk8O5H-RME41nOzHtdrWt5TX1bHXvZ8KrWzHrBu7sqr"+
      "hPzDN-CtIQxk0A1xbACAtnKk2EYKuCeLzqx17UH23-o9bCqq3LamPVgHbI59tYp53m1VfnAH9"+
      "8hZyuN5HaQOuaAnOKzmUMJW-VVjQ8B8v8SBtDjy378FmQ"

    params = {
      :user_id => 'bandmanagertest',
      :auth_key => auth_key
    }
    
    client = Picasa::HTTP::Client.new params
    client.should_not be_nil
    
    params = {
      :user_id => 'bandmanagertest',
      :sub_token => "sub_token"
    }
    
    client = Picasa::HTTP::Client.new params
    client.should_not be_nil
  end
  
  it 'should raise InitializationError in case of not informing the right parameters' do
    lambda { 
      client = Picasa::HTTP::Client.new({}) 
    }.should raise_error Picasa::InitializationException
    
    lambda { 
      client = Picasa::HTTP::Client.new(:user_id => 'user_id') 
    }.should raise_error Picasa::InitializationException
    
    lambda { 
      client = Picasa::HTTP::Client.new(:auth_key => 'auth_key') 
    }.should raise_error Picasa::InitializationException
    
    lambda { 
      client = Picasa::HTTP::Client.new(:sub_token => 'sub_token') 
    }.should raise_error Picasa::InitializationException
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

end
