require 'spec_helper'

describe 'Picasa::HTTP::Photo' do

  before :each do
    delete_all_albums
  end
  
  it 'should get all photos from an album' do
    auth_token = login
    album_id = post_album
    
    header = client_login_header auth_token
    resp, data = Picasa::HTTP::Photo.get_photos 'bandmanagertest', album_id, header
    
    resp.should be_success
    data.should_not be_nil
    data.should_not be_empty
  end
  
  it 'should get one photo from an album' do
    auth_token = login
    album_id, photo_id = post_photo
    
    header = client_login_header auth_token
    resp, data = Picasa::HTTP::Photo.get_photo 'bandmanagertest', album_id, photo_id, header
    
    resp.should be_success
    data.should_not be_nil
    data.should_not be_empty
  end
  
  it 'should post a photo' do
    album_id = post_album
    auth_token = login
    
    file = File.open 'spec/fixture/photo.jpg'
      
    header = client_login_header auth_token
    resp, data = Picasa::HTTP::Photo.post_photo(
      'bandmanagertest', album_id, "Summary", file, header
    )
    
    resp.code.should == "201"
    resp.message.should == "Created"
    data.should_not be_nil
    data.should_not be_empty
    
    doc = Nokogiri::XML data
    doc.at_css('title').content.should == File.basename(file.path)
    doc.at_css('summary').content.should == "Summary"
  end
  
  it 'should do a delete request to delete a photo from an album' do
    album_id, photo_id, auth_token = post_photo
    
    header = client_login_header auth_token
    resp, data = Picasa::HTTP::Photo.delete_photo 'bandmanagertest', album_id, photo_id, header
    resp.should be_success
  end
  
  it 'should do a put request to update a photo' do
    album_id, photo_id, auth_token = post_photo
    
    file = File.open 'spec/fixture/photo2.jpg'
      
    header = client_login_header auth_token
    resp, data = Picasa::HTTP::Photo.update_photo(
      'bandmanagertest', album_id, photo_id, "SummaryUpdated", file, header
    )
    
    resp.code.should == "200"
    resp.message.should == "OK"
    data.should_not be_nil
    data.should_not be_empty
    
    doc = Nokogiri::XML data
    doc.at_css('title').content.should == File.basename(file.path)
    doc.at_css('summary').content.should == "SummaryUpdated"
  end

end
