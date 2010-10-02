#TODO Implement mechanism that verifys if the methods 
# user_id and password were implemented
#
#TODO Mock method calls to the HTTP layer

def act_as_picasa_album
  include Picasa::Album
end

module Picasa::Album
  include Picasa::Util

  # Class methods to be added to the class that will include this module.
    
  module ClassMethods
    
    # Find an album by user_id and album_id. It's mandatory to inform the 
    # authentication token. If no album is found, then an exception is raised.
    
    def find user_id, album_id, auth_token
      resp, data = Picasa::HTTP::Album.get_album user_id, album_id, auth_token
      
      if resp.code != "200" or resp.message != "OK"
        return nil
      end
      
      album = new
      album.send(:populate_attributes, data)
      album
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  attr_reader :id, :author_name, :author_uri, :timestamp, :num_photos, 
              :user, :nickname, :commenting_enable, :comment_count, 
              :media_content_url, :media_thumbnail_url, :user, :photos, :link_edit

  attr_accessor :title, :summary, :location, :keywords

  alias_method :cover_url, :media_content_url
  alias_method :thumbnail_url, :media_thumbnail_url
  
  # Create an album into Picasa's repository. 
  # If cannot create the album throws an exception.
  
  def p_save!
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
    
    populate_attributes data
  end
  
  # Create an album into Picasa's repository. 
  # If cannot create the album return false.
  
  def p_save
    begin
      p_save!
    rescue Exception
      return false
    end
    true
  end
  
  def p_update_attributes! params
    resp, data = Picasa::HTTP::Album.update_album user_id, self.id, auth_token, params

    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error updating album."
    end
    
    populate_attributes data
  end
  
  def p_update_attributes params
    begin
      p_update_attributes! params
    rescue
      return false
    end
    true
  end
  
  def p_update!
    params = {
      :title => title,
      :summary => summary,
      :location => location,
      :keywords => keywords
    }
    p_update_attributes! params
  end
  
  def p_update
    begin
      p_update!
    rescue
      return false
    end
    true
  end
  
  def p_destroy
    resp, data = Picasa::HTTP::Album.delete_album user_id, self.id, auth_token
    
    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error destroying album."
    end
  end
  
  # Authenticate user based on the user_id and password implemented methods and
  # returns the authentication token. If cannot authenticate, raise an exception.
  
  def auth_token
    unless @auth_token
      resp, body = Picasa::HTTP::Authentication.authenticate(user_email, password)
      
      if resp.code != "200" or resp.message != "OK"
        raise Exception, "Error authenticating user. Code = #{resp.code}, Message = #{resp.message}"
      end

      @auth_token = extract_auth_token body
    end
    @auth_token
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
  
  def populate_attributes xml
    doc = Nokogiri::XML xml
    entry = doc.css('entry')
    hash = doc_to_hash entry
    
    hash.keys.each do |k|
      self.instance_variable_set("@#{k}", hash[k])
    end
  end
  
  # Generate a hash representing the attributes of the album from a Nokogiri 
  # document 
  
  def doc_to_hash(doc)
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
