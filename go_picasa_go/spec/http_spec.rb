require 'spec_helper'

describe 'Picasa::HTTP' do
  include Picasa::Util
  
  before :each do
    ids = albums_ids
    if ids and ids.size > 0 
      ids.each do |id|
        delete_album id
      end
    end
  end
  
  it 'should do a post to authenticate' do
    resp, body = Picasa::HTTP.authenticate 'bandmanagertest@gmail.com', '$bandmanager$'
    resp.success?.should be_true
    resp.message_OK?.should be_true
  
    auth_token = extract_auth_token body
    auth_token.should_not be_nil
    auth_token.should_not be_empty
  end
  
  #TODO Fazer um after que destrua o album recem criado
  it 'should do a post to create a album for a user' do
    params = {
      :title => 'testing title',
      :summary => 'testing summary',
      :location => 'testing location',
      :keywords => 'testing keywords' 
    }
    
    auth_token = login
    resp, body = Picasa::HTTP.post_album 'bandmanagertest', auth_token, params
    resp.success?.should be_true
    resp.message.should == "Created"
    
    body.should_not be_nil
    body.should_not be_empty
  end
  
  it 'should do a post request to update albums information' do
    album_id = post_album
    auth_token = login

    params = {
      :title => 'testing title2',
      :summary => 'testing summary2',
      :location => 'testing location2',
      :keywords => 'testing keywords2' 
    }

    album_id = post_album

    resp, body = Picasa::HTTP.update_album "bandmanagertest", album_id, auth_token, params
    resp.success?.should be_true
    resp.message_OK?.should be_true
    
    body.should_not be_nil
    body.should_not be_empty
  end
  
  it 'should do a get to retrieve all albums from user' do
    auth_token = login
    resp, body = Picasa::HTTP.get_albums 'bandmanagertest', auth_token
    resp.success?.should be_true
    resp.message.should == "OK"
    
    body.should_not be_nil
    body.should_not be_empty
  end
    
  it 'should do a get to retrieve one album from a user' do
    album_id = post_album
    
    auth_token = login
    resp, body = Picasa::HTTP.get_album "bandmanagertest", album_id, auth_token
    resp.success?.should be_true
    resp.message_OK?.should be_true
    
    body.should_not be_nil
    body.should_not be_empty
  end
  
  it 'should do a delete request to delete an album from a user' do
    album_id = post_album
    
    auth_token = login
    resp, body = Picasa::HTTP.delete_album "bandmanagertest", album_id, auth_token
    resp.success?.should be_true
    resp.message_OK?.should be_true
    
    resp, body = Picasa::HTTP.get_album "bandmanagertest", album_id, auth_token
    resp.success?.should_not be_true
    resp.message.should == "Not Found"
  end
  
end
