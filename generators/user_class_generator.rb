class UserClassGenerator
  include Singleton
  
  def generate file_name, picasa_id, password
    file_name = underscore file_name
    class_name = camelize file_name
    auth_token = Picasa::Authentication.authenticate picasa_id, password
    create_file file_name, class_name, picasa_id, auth_token
  end
  
  def self.generate file_name, picasa_id, password
    UserClassGenerator.instance.generate file_name, picasa_id, password
  end
  
  private
  
  def underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end	

  def camelize(str)
    str.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
  end
  
  def create_file file_name, class_name, picasa_id, auth_token
    file = File.new "#{file_name}.rb", 'w'

    # Render the user_class template
    template_path = File.dirname(__FILE__) + '/template/'
    template = ERB.new File.open(template_path+"user_class.erb").read
    
    file_body = template.result(binding)
    
    file.write file_body
    file.close
  end
end
 


