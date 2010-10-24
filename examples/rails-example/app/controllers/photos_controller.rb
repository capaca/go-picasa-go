class PhotosController < ApplicationController

  def index
    @user = MyUser.new
    @album = @user.find_album params[:album_id]
    @photos = @album.photos
  end
  
  def show
    @user = MyUser.new
    @album = @user.find_album params[:album_id]
    @foto = @album.find_photo params[:id]
  end
  
end
