require 'net/https'

module Picasa
  require 'rubygems'
  require 'nokogiri'

  class User
    def initialize id
      @id = id
      @albums = []
    end
    
    attr_reader :id, :albums
    
    def sync
      @albums = Picasa::Album.get_albums self
      self
    end
    
  end

  class Album
    
    def initialize(doc, user)
      @id = doc.at_xpath('gphoto:id').content
      @title = doc.at_css('title').content
      @author_name = doc.at_css('author name').content
      @author_uri = doc.at_css('author uri').content
      @timestamp = Time.at(doc.at_xpath('gphoto:timestamp').content.slice(0..9).to_i)
      @num_photos = doc.at_xpath('gphoto:numphotos').content.to_i
      @user = doc.at_xpath('gphoto:user').content
      @nickname = doc.at_xpath('gphoto:nickname').content
      @commenting_enable = doc.at_xpath('gphoto:commentingEnabled').content == "true" ? true : false
      @comment_count = doc.at_xpath('gphoto:commentCount').content.to_i
      @media_content_url = doc.at_xpath('//media:content').attr('url')
      @media_thumbnail_url = doc.at_xpath('//media:thumbnail').attr('url')
      
      @user = user
      @photos = []
    end
    
    attr_reader :id, :title, :author_name, :author_uri, :timestamp, :num_photos, 
                :user, :nickname, :commenting_enable, :comment_count, 
                :media_content_url, :media_thumbnail_url, :user, :photos
    
    alias_method :cover_url, :media_content_url
    alias_method :thumbnail_url, :media_thumbnail_url
    
    def sync
      @photos = Picasa::Photo.get_photos self
      self
    end
    
    def self.get_albums user
      resp, xml = get_albums_xml user.id
      parse(xml, user)
    end
    
    private 
    
    def self.get_albums_xml user_id
      http = Net::HTTP.new('picasaweb.google.com', 80)
      http.get "/data/feed/api/user/#{user_id}"
    end
    
    def self.parse(xml, user)
      albums = []
      doc = Nokogiri::XML(xml)
      doc.css('entry').each do |entry|
        albums << Picasa::Album.new(entry, user).sync
      end
      albums
    end
  end

  class Photo

    def initialize(doc, album)
      @id = doc.at_xpath('gphoto:id').content
      @albumid = doc.at_xpath('gphoto:albumid').content
      @width = doc.at_xpath('gphoto:width').content.to_i
      @height = doc.at_xpath('gphoto:height').content.to_i  
      @size = doc.at_xpath('gphoto:size').content.to_i
      @timestamp = Time.at(doc.at_xpath('gphoto:timestamp').content.slice(0..9).to_i)
      @comment_count = doc.at_xpath('gphoto:commentCount').content.to_i

      @media_title = doc.at_xpath('//media:title').content
      @media_description = doc.at_xpath('//media:description').content

      @media_content_url = doc.at_xpath('//media:content').attr('url')
      @media_thumbnail_url1 = doc.xpath('//media:thumbnail')[0].attr('url')
      @media_thumbnail_url2 = doc.xpath('//media:thumbnail')[1].attr('url')
      @media_thumbnail_url3 = doc.xpath('//media:thumbnail')[2].attr('url')
      
      @album = album
    end
    
    attr_reader :id, :albumid, :width, :height, :size, :timestamp, :comment_count,
                :media_title, :media_description, :media_content_url,
                :media_thumbnail_url1, :media_thumbnail_url2, 
                :media_thumbnail_url3, :album
                
    alias_method :file_name, :media_title
    alias_method :description, :media_description
    alias_method :file_url, :media_content_url
    alias_method :thumbnail_url1,:media_thumbnail_url1          
    alias_method :thumbnail_url2,:media_thumbnail_url2
    alias_method :thumbnail_url3,:media_thumbnail_url3
    
    def thumbnails_urls
      [thumbnail_url1,thumbnail_url2,thumbnail_url3]
    end
    
    def self.get_photos album
      resp, xml = get_photos_xml album.user.id, album.id
      parse xml, album
    end 

    private 
    
    def self.get_photos_xml user_id, album_id
      http = Net::HTTP.new('picasaweb.google.com', 80)
      http.get "/data/feed/api/user/#{user_id}/albumid/#{album_id}"
    end
    
    def self.parse(xml, album)
      photos = []
      doc = Nokogiri::XML(xml)
      doc.css('entry').each do |entry|
        photos << Picasa::Photo.new(entry, album)
      end
      photos
    end      
  end

end

