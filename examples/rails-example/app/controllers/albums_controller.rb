class AlbumsController < ApplicationController
  def index
  end

  def new
  end

  def create
    album = Album.new
    album.user = User.new
    album.title = params[:album][:title]
    album.summary = params[:album][:summary]
    album.location = params[:album][:location]
    album.keywords = params[:album][:keywords]
    
    begin 
      album.picasa_save!
      flash[:notice] = "Salvou a porra do album! Eureka!"
    rescue => e
      flash[:error] = "Deu pau que porra foi essa? #{e}"
    end
    
    render :action => :new
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
