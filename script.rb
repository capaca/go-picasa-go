require 'rubygems'
require 'xmlsimple'
require 'picasa'

resp, body = retrieve_albums
albums = XmlSimple.xml_in body, 'KeyAttr' => 'name'
