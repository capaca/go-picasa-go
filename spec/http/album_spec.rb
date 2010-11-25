require 'spec_helper'

describe 'Picasa::HTTP::Album' do
  include Picasa::Util
  
  before :each do
    delete_all_albums
  end
  
  it 'should do a post to create a album for a user' do
    params = {
      :title => 'testing title',
      :summary => 'testing summary',
      :location => 'testing location',
      :keywords => 'testing keywords' 
    }
    
    auth_token = login
    header = client_login_header(auth_token)
    resp, body = Picasa::HTTP::Album.post_album 'bandmanagertest', params, header
    resp.success?.should be_true
    resp.message.should == "Created"
    
    body.should_not be_nil
    body.should_not be_empty
  end
  
  it 'should create a private album' do
    params = {
      :title => 'testing title',
      :summary => 'testing summary',
      :location => 'testing location',
      :keywords => 'testing keywords',
      :access => 'private'
    }
    
    auth_token = login
    header = client_login_header(auth_token)
    resp, body = Picasa::HTTP::Album.post_album 'bandmanagertest', params, header
    resp.success?.should be_true
    resp.message.should == "Created"
    
    body.should_not be_nil
    body.should_not be_empty
  end
  
  it 'should do a post request to update an album' do
    album_id = post_album
    auth_token = login
    header = client_login_header auth_token

    params = {
      :title => 'testing title2',
      :summary => 'testing summary2',
      :location => 'testing location2',
      :keywords => 'testing keywords2' 
    }

    album_id = post_album
    resp, body = Picasa::HTTP::Album.update_album "bandmanagertest", album_id, params, header
    resp.success?.should be_true
    resp.message_OK?.should be_true
    
    body.should_not be_nil
    body.should_not be_empty
    
    doc = Nokogiri::XML body
    
    doc.at_css('title').content.should == params[:title]
    doc.at_css('summary').content.should == params[:summary]
    doc.at_xpath('//gphoto:location').content.should == params[:location]
    doc.at_xpath('//media:keywords').attribute("value") == params[:keywords]
  end
  
  it 'should do a get to retrieve all albums from user' do
    auth_token = login
    header = client_login_header auth_token
    resp, body = Picasa::HTTP::Album.get_albums 'bandmanagertest', header
    resp.success?.should be_true
    resp.message.should == "OK"
    
    body.should_not be_nil
    body.should_not be_empty
  end
    
  it 'should do a get to retrieve one album from a user' do
    album_id = post_album
    
    auth_token = login
    header = client_login_header auth_token
    resp, body = Picasa::HTTP::Album.get_album "bandmanagertest", album_id, header
    resp.success?.should be_true
    resp.message_OK?.should be_true
    
    body.should_not be_nil
    body.should_not be_empty
  end

  it 'should retrieve a public album with no authentication token' do
    album_id = post_album :access => 'public'
    
    auth_token = login
    header = client_login_header auth_token
    resp, body = Picasa::HTTP::Album.get_album "bandmanagertest", album_id, header
    resp.success?.should be_true
    resp.message_OK?.should be_true
    
    body.should_not be_nil
    body.should_not be_empty
  end
  
  it 'should get 404 if try to retrieve an private album without authorization' do
    album_id = post_album :access => 'private'
    
    resp, body = Picasa::HTTP::Album.get_album "bandmanagertest", album_id, {}
    resp.should_not be_success
    resp.code.should == '404'
  end
  
  it 'should do a delete request to delete an album from a user' do
    album_id = post_album
    
    auth_token = login
    header = client_login_header auth_token
    resp, body = Picasa::HTTP::Album.delete_album "bandmanagertest", album_id, header
    resp.success?.should be_true
    resp.message_OK?.should be_true
    
    resp, body = Picasa::HTTP::Album.get_album "bandmanagertest", album_id, header
    resp.success?.should_not be_true
    resp.message.should == "Not Found"
  end
  
end
