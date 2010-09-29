module Picasa

  module Basic
    def initialize(params = {})
      params.keys.each do |k|
        self.instance_variable_set("@#{k}", params[k])
      end
    end
  end

  module User
    include Basic
    
    attr_reader :id, :albums, :auth_token
    
    def login
      path = '/accounts/ClientLogin'
      http = Net::HTTP.new('www.google.com', 443)
      http.use_ssl=true

      data = "accountType=HOSTED_OR_GOOGLE&Email=#{id}@gmail.com&Passwd=#{@password}&service=lh2&source=BandManager"
      headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

      resp, data = http.post(path, data, headers)
      
      @auth_token = data[/Auth=(.*)/, 1]
      self
    end
    
    def sync
      @albums = Picasa::Album.get_albums self
      self
    end
    
  end

  class Album < BasicObject
    
    attr_reader :id, :author_name, :author_uri, :timestamp, :num_photos, 
                :user, :nickname, :commenting_enable, :comment_count, 
                :media_content_url, :media_thumbnail_url, :user, :photos, :link_edit
    
    attr_accessor :title, :summary, :location, :keywords
    
    alias_method :cover_url, :media_content_url
    alias_method :thumbnail_url, :media_thumbnail_url
    
    def sync
      @photos = Picasa::Photo.get_photos self
      self
    end
    
    # Save an album into the user account. 
    # The attributes used to create the album are:
    #
    # title, summary, location, keywords
    #
    def save
      user.login unless user.auth_token
      headers = {
        "Authorization" => "GoogleLogin auth=#{user.auth_token}",
        "Content-Type" => "application/atom+xml"
      }
      uri = URI.parse "http://picasaweb.google.com/data/feed/api/user/#{user.id}"
      http = Net::HTTP.new(uri.host, uri.port)
      data = "<entry xmlns='http://www.w3.org/2005/Atom' xmlns:media='http://search.yahoo.com/mrss/' xmlns:gphoto='http://schemas.google.com/photos/2007'><title type='text'>#{title}</title><summary type='text'>#{summary}</summary><gphoto:location>#{location}</gphoto:location><gphoto:access>public</gphoto:access><gphoto:timestamp>#{Time.now.to_i}000</gphoto:timestamp><media:group><media:keywords>#{keywords}</media:keywords></media:group><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#album'></category></entry>"
      resp = http.post(uri.path, data, headers)
      puts resp.inspect
      self
    end
    
    def update
      user.login #unless user.auth_token
      headers = {
        "Authorization" => "GoogleLogin auth=#{user.auth_token}",
        "Content-Type" => "application/atom+xml",
        "If-Match" => "*"
      }
      uri = URI.parse "http://picasaweb.google.com/data/entry/api/user/#{user.id}/albumid/#{id}"#link_edit
      http = Net::HTTP.new(uri.host, uri.port)
      resp = http.send_request('PUT',uri.path, self.to_xml, headers)
      puts resp.inspect
      self
    end
    
    # Generate the xml representation of the album object
    # PS: the attributes title, summary, location
    #     are the only ones that change after the album creation.
    def to_xml
      xml = Album.retrieve user, id
      doc = Nokogiri::XML xml
      doc.at_css('title').content = title
      doc.at_css('summary').content = summary
      doc.at_xpath('//gphoto:location').content = location
      doc.to_xml
    end
    
    def self.retrieve(user, album_id)
      puts user.auth_token
      
      headers = {
        "Authorization" => "GoogleLogin auth=#{user.auth_token}",
        "Content-Type" => "application/atom+xml"
      }
      
      http = Net::HTTP.new('picasaweb.google.com', 80)
      resp, xml = http.get "/data/entry/api/user/#{user.id}/albumid/#{album_id}", headers
      
      return xml
    end
    
    def self.get_albums user
      resp, xml = get_albums_xml user
      puts xml
      parse(xml, user)
    end
    
    def self.get_albums_xml user
      user.login unless user.auth_token
    
      headers = {
        "Authorization" => "GoogleLogin auth=#{user.auth_token}",
        "Content-Type" => "application/atom+xml"
      }
      
      http = Net::HTTP.new('picasaweb.google.com', 80)
      http.get "/data/feed/api/user/#{user.id}", headers
    end

    private 
    
    def self.parse(xml, user)
      albums = []
      doc = Nokogiri::XML(xml)
      doc.css('entry').each do |entry|
        hash = Picasa::Album.parse_entry(entry)
        hash[:user] = user
        albums << Picasa::Album.new(hash).sync
      end
      albums
    end
    
    def self.parse_entry(doc)
      hash = {
        :id => doc.at_xpath('gphoto:id').content,
        :title => doc.at_css('title').content,
        :author_name => doc.at_css('author name').content,
        :author_uri => doc.at_css('author uri').content,
        :timestamp => Time.at(doc.at_xpath('gphoto:timestamp').content.slice(0..9).to_i),
        :num_photos => doc.at_xpath('gphoto:numphotos').content.to_i,
        :user => doc.at_xpath('gphoto:user').content,
        :nickname => doc.at_xpath('gphoto:nickname').content,
        :commenting_enable => doc.at_xpath('gphoto:commentingEnabled').content == "true" ? true : false,
        :comment_count => doc.at_xpath('gphoto:commentCount').content.to_i,
        :media_content_url => doc.at_xpath('//media:content').attr('url'),
        :media_thumbnail_url => doc.at_xpath('//media:thumbnail').attr('url'),
        :link_edit => doc.at_css('link[@rel="edit"]').attr('href')
      }
    end
    
  end

  class Photo < BasicObject
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
        hash = Picasa::Photo.parse_entry(entry)
        hash[:album] = album
        photos << Picasa::Photo.new(hash)
      end
      photos
    end
    
    def self.parse_entry doc
      hash = {
        :id => doc.at_xpath('gphoto:id').content,
        :albumid => doc.at_xpath('gphoto:albumid').content,
        :width => doc.at_xpath('gphoto:width').content.to_i,
        :height => doc.at_xpath('gphoto:height').content.to_i,  
        :size => doc.at_xpath('gphoto:size').content.to_i,
        :timestamp => Time.at(doc.at_xpath('gphoto:timestamp').content.slice(0..9).to_i),
        :comment_count => doc.at_xpath('gphoto:commentCount').content.to_i,
        :media_title => doc.at_xpath('//media:title').content,
        :media_description => doc.at_xpath('//media:description').content,
        :media_content_url => doc.at_xpath('//media:content').attr('url'),
        :media_thumbnail_url1 => doc.xpath('//media:thumbnail')[0].attr('url'),
        :media_thumbnail_url2 => doc.xpath('//media:thumbnail')[1].attr('url'),
        :media_thumbnail_url3 => doc.xpath('//media:thumbnail')[2].attr('url')
      }
    end      
  end

end

