class Picasa::AuthSubSession < Picasa::Session
  
  attr_accessor :user_id, :auth_sub_token
  
  def initialize user_id, auth_sub_token
    super user_id
    @auth_sub_token = auth_sub_token
  end
  
  def albums
    client.get_albums
  end
  
  def find_album album_id
    resp, data = client.get_album album_id
      
    if resp.code != "200" or resp.message != "OK"
      return nil
    end
    
    album = album_class.new
    album.send(:populate_attributes_from_xml, data)
    album
  end
  
  private
  
  def album_class
    Picasa::DefaultAlbum
  end
  
  def client
    @client ||= Picasa::AuthSubAlbum.new(user_id, auth_sub_token)
  end
  
end
