class AlbumsController < ApplicationController
  def index
    @user = MyUser.new
    @albums = @user.albums
  end

  def new
    @album = Picasa::DefaultAlbum.new
  end

  def create
    @album = Picasa::DefaultAlbum.new
    @album.user = MyUser.new
    @album.title = params[:album][:title]
    @album.summary = params[:album][:summary]
    @album.location = params[:album][:location]
    @album.access = params[:album][:access]
    
    begin 
      @album.picasa_save!
      flash[:notice] = "Album created succefully!"
    rescue Exception => e
      flash[:error] = "Error while saving the album."
      render :action => :new
      return
    end
    
    redirect_to :action => :new    
  end

  def edit
    @user = MyUser.new
    @album = @user.find_album params[:id]
  end

  def update
    @user = MyUser.new
    @album = @user.find_album params[:id]
    
    begin 
      @album.picasa_update_attributes! params[:album]
      flash[:notice] = "Album updated succefully!"
    rescue Exception => e
      puts e.inspect
      flash[:error] = "Error while updating the album."
      render :action => :edit
      return
    end
    
    redirect_to :action => :edit, :id => @album.picasa_id
  end

  def destroy
    @user = MyUser.new
    @album = @user.find_album params[:id]
    @album.destroy!
    
    redirect_to :action => :index
  end

end
