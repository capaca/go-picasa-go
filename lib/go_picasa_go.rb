require 'net/https'
require 'erb'
require 'tmpdir'
require 'rubygems'
require 'nokogiri'
require 'patchs/ssl'
require 'picasa/http/authentication'
require 'picasa/http/album'
require 'picasa/http/photo'
require 'picasa/util'
require 'picasa/authentication'
require 'picasa/user'
require 'picasa/album'
require 'picasa/photo'
require 'patchs/object'
require 'singleton'
require 'generators/user_class_generator'

include Picasa::Util

require 'picasa/default_user'
require 'picasa/default_photo'
require 'picasa/default_album'


