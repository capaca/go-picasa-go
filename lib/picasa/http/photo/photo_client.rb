module Picasa::HTTP::PhotoClient
  
  def get_photos
    Picasa::HTTP::Photo.get_photos @user_id, @album_id, auth_header
  end
  
  def get_photo photo_id
    Picasa::HTTP::Photo.get_photo @user_id, @album_id, photo_id, auth_header
  end
  
  def post_photo summary, file
    Picasa::HTTP::Photo.post_photo @user_id, @album_id, summary, file, auth_header
  end
  
  def update_photo photo_id, summary, file
    Picasa::HTTP::Photo.update_photo @user_id, @album_id, photo_id, summary, file, auth_header
  end 
  
  def delete_photo photo_id
    Picasa::HTTP::Photo.delete_photo @user_id, @album_id, photo_id, auth_header
  end
  
end

