require 'lib/go_picasa_go'
require 'http_response_helper'
require 'mock_helper'

include Picasa::Util
include MockHelper

class UserObject
  acts_as_picasa_user
  has_many_picasa_albums :class_name => "AlbumObject"
  
  def picasa_id
    "bandmanagertest"
  end
  
  def auth_token
    'DQAAAHsAAAASi_ADDIYHfjjeN5S3zxA3CTyrljizPKcig62QAR5FvdZNLY6CgeHPl0R1LFQvE9z'+
    '-DOni2gFHMNrHVObg1yY71DbzoVfZnJN9jGSsMTw4pVTLA9XKifzirGtrr2EUoFncGXVBIbDUrom'+
    'n7hK3Bb14Kp--HzGcQj4pg1hXZch3Gg'
  end
end

class AlbumObject
  acts_as_picasa_album
  belongs_to_picasa_user :class_name => "UserObject"
end

class PhotoObject
  acts_as_picasa_photo
  belongs_to_picasa_album :class_name => 'AlbumObject'
end

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

def create_album
  user = UserObject.new
  user.picasa_id = "bandmanagertest"
  
  album = AlbumObject.new
  album.user = user
  album.title = "Album Title"
  album.summary = "Album Summary"
  album.location = "Album location"
  album.keywords = "Album keywords"
  
  album.picasa_save!
  album
end

def post_photo
  album_id = post_album
  auth_token = login

  file = File.open 'spec/fixture/photo.jpg'

  resp, data = Picasa::HTTP::Photo.post_photo(
    'bandmanagertest', album_id, auth_token, "Summary", file
  )

  resp.code.should == "201"
  resp.message.should == "Created"
  data.should_not be_nil
  data.should_not be_empty

  doc = Nokogiri::XML data
  photo_id = doc.at_xpath('//gphoto:id').content
  [album_id, photo_id, auth_token]
end

def create_photo
  album = create_album
  file = File.open 'spec/fixture/photo.jpg'
  
  photo = PhotoObject.new
  photo.album = album
  photo.summary = "Photo summary"
  photo.file = file
  
  photo.picasa_save.should be_true
  photo
end
