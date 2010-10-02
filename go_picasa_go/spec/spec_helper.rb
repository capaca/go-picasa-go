require 'lib/go_picasa_go'
require 'http_response_helper'
require 'mock_helper'

include Picasa::Util
include MockHelper

def login(email = 'bandmanagertest@gmail.com', password = '$bandmanager$')
  resp, body = Picasa::HTTP::Authentication.authenticate(email, password)
  resp.code.should == "200"
  resp.message.should == "OK"

  auth_token = extract_auth_token body
  auth_token.should_not be_nil
  auth_token.should_not be_empty
  
  auth_token
end

def post_album opts = {}
  params = {
    :title => 'testing title',
    :summary => 'testing summary',
    :location => 'testing location',
    :keywords => 'testing keywords' 
  }
  
  auth_token = login
  resp, body = Picasa::HTTP::Album.post_album 'bandmanagertest', auth_token, params.merge(opts)
  resp.success?.should be_true
  resp.message.should == "Created"

  body.should_not be_nil
  body.should_not be_empty

  doc = Nokogiri::XML body
  doc.at_xpath('//gphoto:id').content
end

def delete_album album_id
  auth_token = login
  resp, body = Picasa::HTTP::Album.delete_album "bandmanagertest", album_id, auth_token
  resp.success?.should be_true
  resp.message_OK?.should be_true
end

def albums_ids
  auth_token = login
  resp, body = Picasa::HTTP::Album.get_albums('bandmanagertest', auth_token)
  
  resp.should_not be_nil
  body.should_not be_nil
  
  resp.success?.should be_true
  resp.message.should == "OK"
  
  body.should_not be_empty
  
  doc = Nokogiri.XML body
  ids = []
  doc.css('entry').each do |entry|
    ids << entry.at_css('id').content.split("albumid/")[1].to_i
    ids.uniq!
  end
  
  ids
end

def delete_all_albums
  ids = albums_ids
  if ids and ids.size > 0 
    ids.each do |id|
      delete_album id
    end
  end
end
