#TODO Implement the all method that returns all albums for a user
def act_as_picasa_album
  include Picasa::Album
end

module Picasa::Album
  include Picasa::Util

  # Class methods to be added to the class that will include this module.
    
  module ClassMethods
    
    def belongs_to_picasa_user params
      unless params[:class_name] and params[:class_name].class == String
        raise Exception, 'You should pass the string of the class name that includes Picasa::User.'
      end
      
      (class << self; self; end).instance_eval { 
        define_method :user_class do
          eval(params[:class_name])  
        end 
      }
      
      define_method :user_class do
        eval(params[:class_name])
      end
    end
    
    # Find an album by user_id and album_id. It's mandatory to inform the 
    # authentication token. If no album is found, then an exception is raised.
    
    def picasa_find user_id, album_id, auth_token
      resp, data = Picasa::HTTP::Album.get_album user_id, album_id, auth_token
      
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
      resp, data = Picasa::HTTP::Album.get_albums user_id, auth_token
      
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
    
    def create_user user_id, auth_token
      user = user_class.new
      user.user_id = user_id
      user.auth_token = auth_token
      user 
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  attr_reader :id, :author_name, :author_uri, :timestamp, :num_photos, 
              :nickname, :commenting_enable, :comment_count, 
              :media_content_url, :media_thumbnail_url, :user, :photos, :link_edit

  attr_accessor :title, :summary, :location, :keywords, :user

  alias_method :cover_url, :media_content_url
  alias_method :thumbnail_url, :media_thumbnail_url
  
  # Create an album into Picasa's repository. 
  # If cannot create the album throws an exception.
  
  def picasa_save!
    params = {
      :title => title,
      :summary => summary,
      :location => location,
      :keywords => keywords
    }
    
    resp, data = Picasa::HTTP::Album.post_album(user_id, auth_token, params)
    
    if resp.code != "201" or resp.message != "Created"
      raise Exception, "Error creating album: #{resp.message}."
    end
    
    populate_attributes_from_xml data
  end
  
  # Create an album into Picasa's repository. 
  # If cannot create the album return false.
  
  def picasa_save
    begin
      picasa_save!
    rescue Exception
      return false
    end
    true
  end
  
  # Update the attributes of an album.
  # If cannot update, an exception is raised.
  
  def picasa_update_attributes! params
    resp, data = Picasa::HTTP::Album.update_album user_id, self.id, auth_token, params

    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error updating album."
    end
    
    populate_attributes_from_xml data
  end
  
  # Update the attributes of an album.
  # If cannot update, return false.
  
  def picasa_update_attributes params
    begin
      picasa_update_attributes! params
    rescue
      return false
    end
    true
  end
  
  # Update the whole album.
  # If cannot update, an exception is raised.
  
  def picasa_update!
    params = {
      :title => title,
      :summary => summary,
      :location => location,
      :keywords => keywords
    }
    picasa_update_attributes! params
  end
  
  # Update the whole album.
  # If cannot update, returns false.
  
  def picasa_update
    begin
      picasa_update!
    rescue
      return false
    end
    true
  end
  
  # Destroy the current album. 
  # If cannot destroy it, an exception is raised.
  
  def picasa_destroy!
    resp, data = Picasa::HTTP::Album.delete_album user_id, self.id, auth_token
    
    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error destroying album."
    end
  end
  
  # Destroy the current album and returns true. 
  # If cannot destroy it, returns false.
  
  def picasa_destroy
    begin
      picasa_destroy!
    rescue
      return false
    end
    true
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
      :id => doc.at_xpath('//gphoto:id').content,
      :title => doc.at_css('title').content,
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
  
  def user_id
    @user.user_id
  end
  
  def auth_token
    @user.auth_token
  end

end
