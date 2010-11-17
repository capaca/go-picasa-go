class Picasa::HTTP::Client
  
  include Picasa::HTTP::Album
  
  def initialize params
    unless params[:user_id] and (params[:auth_key] or params[:sub_token])
      raise Picasa::InitializationException
    end
    
    @user_id = params[:user_id]
    @auth_key = params[:auth_key]
  end
  
  def get_albums
    Picasa::HTTP::Album.get_albums @user_id, @auth_key
  end
  
  def get_album album_id
    Picasa::HTTP::Album.get_album @user_id, album_id, @auth_key
  end
  
  def post_album params
    Picasa::HTTP::Album.post_album @user_id, @auth_key, params
  end
  
  def update_album album_id, params
    Picasa::HTTP::Album.post_album @user_id, album_id, @auth_key, params
  end
  
end
