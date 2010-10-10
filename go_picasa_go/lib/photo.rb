# Module that offers methods to do high level operations concerning
# a album within Picasa.

module Picasa::Photo
  
  # Class methods to be added to the class that will include this module.
    
  module ClassMethods
  
    # Sets the user class configured so it can be used later.
  
    def belongs_to_picasa_album params
      unless params[:class_name] and params[:class_name].class == String
        raise Exception, 'You should pass the string of the class name that includes Picasa::Album.'
      end
      
      define_dependent_class_methods :album_class, params[:class_name]
    end
    
    # Find a photo by user_id, album_id and photo_id
    # If no album is found, then an exception is raised.
    
    def picasa_find user_id, album_id, photo_id, auth_token
      
      resp, data = Picasa::HTTP::Photo.get_photo user_id, album_id, photo_id
      
      if resp.code != "200" or resp.message != "OK"
        raise Exception, "Photo not found"
      end
      
      photo = new
      photo.send(:populate_attributes_from_xml, data)
      photo.album = album_class.picasa_find user_id, album_id, auth_token
      photo
    end
    
    # Find all photos from an album using user_id, album_id
    # If no album is found, then an exception is raised.
    
    def picasa_find_all user_id, album_id, auth_token
      photos = []
      resp, data = Picasa::HTTP::Photo.get_photos user_id, album_id
      
      if resp.code != "200" or resp.message != "OK"
        return nil
      end
      
      doc = Nokogiri::XML(data)
      doc.css('entry').each do |entry|
        photo = new
        photo.send(:populate_attributes, entry)
        photo.album = album_class.picasa_find user_id, album_id, auth_token
        photos << photo
      end
      photos
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  attr_reader :picasa_id, :albumid, :width, :height, :size, :timestamp, :comment_count,
              :media_title, :media_description, :media_content_url,
              :media_thumbnail_url1, :media_thumbnail_url2, 
              :media_thumbnail_url3, :album
  
  attr_accessor :album, :summary, :file
  
  # Post a photo into a picasa album.
  # If cannot post, an exception is raised.
  
  def picasa_save!
    resp, data = Picasa::HTTP::Photo.post_photo user_id, album_id, auth_token, summary, file
    
    if resp.code != "201" or resp.message != "Created"
      raise Exception, "Error posting photo: #{resp.message}."
    end
    
    populate_attributes_from_xml data
  end
  
  # Post a photo into a picasa album.
  # If cannot post, returns false.
  
  def picasa_save
    raise_exception? do
      self.picasa_save!
    end
  end
  
  # Update photo's file and metadata.
  # If cannot update, an exception is raised.
  
  def picasa_update!
    resp, data = Picasa::HTTP::Photo.update_photo(
      'bandmanagertest', album_id, picasa_id, auth_token, summary, file
    )
    
    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error updating photo: #{resp.message}."
    end
    
    populate_attributes_from_xml data
  end
  
  # Update photo's file and metadata.
  # If cannot update, returns false.
  
  def picasa_update
    raise_exception? do
      self.picasa_update!
    end
  end
  
  # Delete the current photo from album.
  # If cannot delete, an exception is raised.
  
  def destroy!
    resp, data = Picasa::HTTP::Photo.delete_photo user_id, album_id, picasa_id, auth_token
    
    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error destroying photo: #{resp.message}."
    end
  end
  
  # Delete the current photo from album.
  # If cannot delete, an exception is raised.
  
  def destroy
    raise_exception? do
      self.destroy
    end
  end
  
  private 
  
  def populate_attributes_from_xml xml
    doc = Nokogiri::XML xml
    entry = doc.css('entry')
    populate_attributes entry
  end

  def populate_attributes doc
    hash = doc_to_hash doc
    
    hash.keys.each do |k|
      self.instance_variable_set("@#{k}", hash[k])
    end    
  end

  def doc_to_hash doc
    hash = {
      :picasa_id => doc.at_xpath('gphoto:id').content,
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
  
  def user_id
    @album.user.picasa_id
  end
  
  def album_id
    @album.picasa_id
  end
  
  def auth_token
    @album.user.auth_token
  end
end
