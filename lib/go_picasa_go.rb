require 'logger'
require 'net/https'
require 'erb'
require 'tmpdir'
require 'rubygems'
require 'nokogiri'
require 'patchs/ssl'
require 'picasa/http/authentication'
require 'picasa/http/auth_sub'

#Picasa::HTTP::Album
require 'picasa/http/album/album'
require 'picasa/http/album/album_client'
require 'picasa/http/album/auth_sub_album'

#Picasa::HTTP::Photo
require 'picasa/http/photo/photo'
require 'picasa/http/photo/photo_client'
require 'picasa/http/photo/auth_sub_photo'

require 'picasa/util'
require 'picasa/missing'
require 'picasa/authentication'
require 'picasa/user'
require 'picasa/album'
require 'picasa/photo'
require 'picasa/exceptions'
require 'patchs/object'
require 'singleton'
require 'generators/user_class_generator'
require 'picasa/session'
require 'picasa/auth_sub_session'

include Picasa::Util

require 'picasa/default_user'
require 'picasa/default_photo'
require 'picasa/default_album'


