module Picasa::HTTP::AlbumClient
  
  def get_albums
    Picasa::HTTP::Album.get_albums @user_id, auth_header
  end
  
  def get_album album_id
    Picasa::HTTP::Album.get_album @user_id, album_id, auth_header
  end
  
  def post_album params
    Picasa::HTTP::Album.post_album @user_id, params, auth_header
  end
  
  def update_album album_id, params
    Picasa::HTTP::Album.update_album @user_id, album_id, params, auth_header
  end
  
  def delete_album album_id
    Picasa::HTTP::Album.delete_album @user_id, album_id, auth_header
  end
end


