require 'picasa'

@user = Picasa::User.new(:id => 'pedro.capaca', :password => 'ba159ga')
@user.sync

@album = @user.albums.first

