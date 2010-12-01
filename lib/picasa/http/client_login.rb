class Picasa::ClientLogin
  include Picasa::HTTP::AlbumClient
  include Picasa::HTTP::PhotoClient
  
  def initialize user_id, token
    @user_id = user_id
    @token = token
  end
  
  private

  def auth_header
    return {"Authorization" => "GoogleLogin auth=\"#{@token}\""}
  end
end
