def act_as_picasa_photo
  include Picasa::Photo
end

module Picasa::Photo
    
  module ClassMethods
  
    def belongs_to_picasa_album params
      unless params[:class_name] and params[:class_name].class == String
        raise Exception, 'You should pass the string of the class name that includes Picasa::Album.'
      end
      
      define_dependent_class_methods :album_class, params[:class_name]
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  attr_reader :id, :albumid, :width, :height, :size, :timestamp, :comment_count,
              :media_title, :media_description, :media_content_url,
              :media_thumbnail_url1, :media_thumbnail_url2, 
              :media_thumbnail_url3, :album
  
  attr_accessor :album, :summary, :file
  
  def picasa_save!
    resp, data = Picasa::HTTP::Photo.post_photo user_id, album_id, auth_token, summary, file
    
    if resp.code != "201" or resp.message != "Created"
      raise Exception, "Error posting photo: #{resp.message}."
    end
    
    populate_attributes_from_xml data
  end
  
  def picasa_save
    raise_exception? do
      self.picasa_save!
    end
  end
  
  def picasa_update!
    resp, data = Picasa::HTTP::Photo.update_photo(
      'bandmanagertest', album_id, id, auth_token, summary, file
    )
    
    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error updating photo: #{resp.message}."
    end
    
    populate_attributes_from_xml data
  end
  
  def picasa_update
    raise_exception? do
      self.picasa_update!
    end
  end
  
  def destroy!
    resp, data = Picasa::HTTP::Photo.delete_photo user_id, album_id, id, auth_token
    
    if resp.code != "200" or resp.message != "OK"
      raise Exception, "Error destroying photo: #{resp.message}."
    end
  end
  
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
  
  def user_id
    @album.user.user_id
  end
  
  def album_id
    @album.id
  end
  
  def auth_token
    @album.user.auth_token
  end
end
