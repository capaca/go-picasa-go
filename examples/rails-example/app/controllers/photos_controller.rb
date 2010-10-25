class PhotosController < ApplicationController

  def index
    @user = MyUser.new
    @album = @user.find_album params[:album_id]
    @photos = @album.photos
  end
  
  def new
    @user = MyUser.new
    @album = @user.find_album params[:album_id]
  end
  
  def create
    file = params[:photo][:file]
    
    file_name = File.dirname(file.path)+"/#{file.original_filename}" 
    
    photo_file = File.new file_name, 'w+'
    photo_file.write file.readlines
    photo_file.close
    
    @album = MyUser.new.find_album params[:album_id]
    
    @photo = Picasa::DefaultPhoto.new
    @photo.album = @album 
    @photo.file = photo_file
    
    begin
      @photo.save!
    rescue
      flash[:error] = "Error while trying to save the photo."
      render :template => :new
      return
    end
    
    flash[:notice] = "The photo was uploaded succefully!"
    redirect_to album_photos_path(params[:album_id])
  end
  
  def update
    @album = MyUser.new.find_album params[:album_id]
    @photo = @album.find_photo params[:id]
    @photo.description = params[:photo][:description]
    
    begin
      @photo.picasa_update!
    rescue Exception => e
      puts e.inspect
      flash[:error] = "Error while trying to update the photo."
      render :action => :new
      puts "Deu pau!"
      return    
    end
    
    puts "Vamos lá!"
    redirect_to album_photo_path(params[:album_id], params[:id])
  end
  
  def show
    @user = MyUser.new
    @album = @user.find_album params[:album_id]
    @photo = @album.find_photo params[:id]
    puts @photo.inspect
  end
  
  def destroy
    @user = MyUser.new
    @album = @user.find_album params[:album_id]
    @foto = @album.find_photo params[:id]
    @foto.destroy!
    
    flash[:notice] = "Photo delete succefully!"
    redirect_to album_photos_path(@album.picasa_id)
  end
  
end
