# Module that offers methods to do high level operations concerning
# a album within Picasa.

module Picasa::Photo
  
  include Picasa::Missing

  attr_reader :picasa_id, :albumid, :width, :height, :size, :timestamp, :comment_count,
              :media_title, :media_content_url,
              :media_thumbnail_url1, :media_thumbnail_url2, 
              :media_thumbnail_url3, :album
  
  attr_accessor :album, :description, :file
  
  # Post a photo into a picasa album.
  # If cannot post, an exception is raised.
  
  def picasa_save!
    if self.picasa_id and self.picasa_id.length > 0
      return picasa_update!
    end
    
    resp, data = client.post_photo description, file
    
    if resp.code != "201" or resp.message != "Created"
      raise Picasa::Exception, "Error posting photo: #{resp.message}."
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
    resp, data = client.update_photo picasa_id, description, file
    
    if resp.code != "200" or resp.message != "OK"
      raise Picasa::Exception, "Error updating photo: #{resp.message}."
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
      raise Picasa::Exception, "Error destroying photo: #{resp.message}."
    end
  end
  
  # Delete the current photo from album.
  # If cannot delete, an exception is raised.
  
  def destroy
    raise_exception? do
      self.destroy!
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
      :picasa_id => doc.at_xpath('.//gphoto:id').content,
      :albumid => doc.at_xpath('.//gphoto:albumid').content,
      :width => doc.at_xpath('.//gphoto:width').content.to_i,
      :height => doc.at_xpath('.//gphoto:height').content.to_i,  
      :size => doc.at_xpath('./gphoto:size').content.to_i,
      :timestamp => Time.at(doc.at_xpath('.//gphoto:timestamp').content.slice(0..9).to_i),
      :comment_count => doc.at_xpath('.//gphoto:commentCount').content.to_i,
      :media_title => doc.at_xpath('.//media:title').content,
      :description => doc.at_xpath('.//media:description').content,
      :media_content_url => doc.at_xpath('.//media:content').attr('url'),
      :media_thumbnail_url1 => doc.xpath('.//media:thumbnail')[0].attr('url'),
      :media_thumbnail_url2 => doc.xpath('.//media:thumbnail')[1].attr('url'),
      :media_thumbnail_url3 => doc.xpath('.//media:thumbnail')[2].attr('url')
    }
  end

  #FIXME Duplicated implementation (also in album).
  def client
    @client ||= Picasa::AuthSubPhoto.new(user_id, album_id, auth_sub_token)
  end
end
