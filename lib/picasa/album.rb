# Module that offers methods to do high level operations concerning
# a album within Picasa.

module Picasa::Album

  include Picasa::Missing   

  # Class methods to be added to the class that will include this module.
    
  module ClassMethods
    include Picasa::Util
    
    # Sets the user class configured so it can be used later.
    
    def belongs_to_picasa_user params
      unless params[:class_name] and params[:class_name].class == String
        raise Exception, 'You should pass the string of the class name that includes Picasa::User.'
      end
      
      define_dependent_class_methods :user_class, params[:class_name]
    end
    
    # Method used to tell the gem what is the class that implements the
    # Picasa::Photo module.
    
    def has_many_picasa_photos params
      unless params[:class_name] and params[:class_name].class == String
        raise Exception, 'You should pass the string of the class name that includes Picasa::Album.'
      end

      define_dependent_class_methods :photo_class, params[:class_name]      
    end
    
    def picasa_auth_sub user_id, sub_token
      @@user_id = user_id
      @@sub_token = sub_token
    end
    
    # Find an album by user_id and album_id. It's mandatory to inform the 
    # authentication token. If no album is found, then an exception is raised.
    
    def picasa_find user_id, album_id, auth_token
      resp, data = client.get_album album_id
      
      if resp.code != "200" or resp.message != "OK"
        return nil
      end
      
      album = new
      album.send(:populate_attributes_from_xml, data)
      album.user = create_user user_id, auth_token
      album
    end
    
    # Find an album by user_id and album_id. It's mandatory to inform the 
    # authentication token. If no album is found, then an exception is raised.
    
    def picasa_find_all user_id, auth_token
      albums = []
      resp, data = client.get_albums
      
      if resp.code != "200" or resp.message != "OK"
        return nil
      end
      
      doc = Nokogiri::XML(data)
      doc.css('entry').each do |entry|
        album = new
        album.send(:populate_attributes, entry)
        album.user = create_user user_id, auth_token
        albums << album
      end
      albums
    end
    
    private
    
    def client
      @@client ||= Picasa::AuthSub.new @@user_id, @@sub_token
    end
    
    def create_user picasa_id, auth_token
      user = user_class.new
      user.picasa_id = picasa_id
      user.auth_token = auth_token
      user 
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    self.class.define_dependent_class_methods :user_class, 'Picasa::DefaultUser'
    self.class.define_dependent_class_methods :photo_class, 'Picasa::DefaultPhoto'
    define_dependent_class_methods :user_class, 'Picasa::DefaultUser'
    define_dependent_class_methods :photo_class, 'Picasa::DefaultPhoto'
  end
  
  attr_reader :picasa_id, :author_name, :author_uri, :timestamp, :num_photos, 
              :nickname, :commenting_enable, :comment_count, 
              :media_content_url, :media_thumbnail_url, :user, :link_edit

  attr_accessor :title, :summary, :location, :keywords, :user, :access

  alias_method :cover_url, :media_content_url
  alias_method :thumbnail_url, :media_thumbnail_url
  
  # Post an album into Picasa. 
  # If cannot create the album an exception is raised.
  
  def picasa_save!
    if self.picasa_id and picasa_id.length > 0
      return self.picasa_update!
    end
    
    params = build_params_hash
    
    resp, data = client.post_album params
    
    if resp.code != "201" or resp.message != "Created"
      raise "Error creating album: #{resp.message}."
    end
    
    populate_attributes_from_xml data
    self
  end

  # Post an album into Picasa.
  # If cannot create the album returns false.
  
  def picasa_save
    raise_exception? do
      picasa_save!
    end
  end
  
  # Update the attributes of the current album.
  # If cannot update, an exception is raised.
  
  def picasa_update_attributes! params
    resp, data = client.update_album self.picasa_id, params

    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error updating album."
    end
    
    populate_attributes_from_xml data
  end
  
  # Update the attributes of the current album.
  # If cannot update, return false.
  
  def picasa_update_attributes params
    raise_exception? do
      picasa_update_attributes! params
    end
  end
  
  # Update all attributes of the current album.
  # If cannot update, an exception is raised.
  
  def picasa_update!
    params = build_params_hash
    picasa_update_attributes! params
  end

  # Update all attributes of the current album.
  # If cannot update, returns false.
  
  def picasa_update
    raise_exception? do
      picasa_update!
    end
  end
  
  
  # Destroy the current album. 
  # If cannot destroy it, an exception is raised.
  
  def picasa_destroy!
    resp, data = client.delete_album self.picasa_id
    
    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error destroying album."
    end
  end
  
  # Destroy the current album and returns true. 
  # If cannot destroy it, returns false.
  
  def picasa_destroy
    raise_exception? do
      picasa_destroy!
    end
  end
  
  def find_photo photo_id
    photo_class.picasa_find user_id, picasa_id, photo_id, auth_token
  end
  
  # Find all photos from the current album. The operation is done only one time
  # for an instance, if it it's needed to do it to refresh the data you can 
  # pass the parameter true so it can be reloaded.
  
  def photos(reload = false)
    @photos = photo_class.picasa_find_all user_id, picasa_id, auth_token if reload
    @photos ||= photo_class.picasa_find_all user_id, picasa_id, auth_token
  end
  
  ##############################################################################
  # Private Methods                                                            #
  ##############################################################################

  private 

  # Returns the user email based on the user_id methods
  
  def user_email
    "#{user_id}@gmail.com"
  end
  
  # Populates the attributes of the object based on the xml
  
  def populate_attributes doc
    hash = doc_to_hash doc
    
    hash.keys.each do |k|
      self.instance_variable_set("@#{k}", hash[k])
    end
  end
  
  def populate_attributes_from_xml xml
    doc = Nokogiri::XML xml
    entry = doc.css('entry')
    populate_attributes entry
  end
  
  # Generate a hash representing the attributes of the album from a Nokogiri 
  # document 
  
  def doc_to_hash(doc)
    hash = {
      :picasa_id => doc.at_xpath('//gphoto:id').content,
      :title => doc.at_css('title').content,
      :summary => doc.at_css('summary').content,
      :location => doc.at_xpath('gphoto:location').content,
      :keywords => doc.at_xpath('//media:keywords').content,
      :access => doc.at_xpath('gphoto:access').content,
      :author_name => doc.at_css('author name').content,
      :author_uri => doc.at_css('author uri').content,
      :timestamp => Time.at(doc.at_xpath('gphoto:timestamp').content.slice(0..9).to_i),
      :num_photos => doc.at_xpath('gphoto:numphotos').content.to_i,
      :nickname => doc.at_xpath('gphoto:nickname').content,
      :commenting_enable => doc.at_xpath('gphoto:commentingEnabled').content == "true" ? true : false,
      :comment_count => doc.at_xpath('gphoto:commentCount').content.to_i,
      :media_content_url => doc.at_xpath('//media:content').attr('url'),
      :media_thumbnail_url => doc.at_xpath('//media:thumbnail').attr('url'),
      :link_edit => doc.at_css('link[@rel="edit"]').attr('href')
    }
  end
  
  def build_params_hash
    {
      :title => title,
      :summary => summary,
      :location => location,
      :keywords => keywords,
      :access => access
    }
  end
  
  def user_id
    @user.picasa_id
  end
  
  def auth_token
    @user.auth_token
  end
  
  def client
    unless @client
      if defined? user_id and defined? auth_sub_token
        @client = Picasa::AuthSub.new(user_id, auth_sub_token)
      else
        @client = self.class.send :client
      end
    end
    @client
  end

end
