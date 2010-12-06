class Picasa::AuthSubPhoto < Picasa::AuthSub 
  include Picasa::HTTP::PhotoClient
  
  def initialize user_id, album_id, token
    @album_id = album_id
    super user_id, token
  end
end
