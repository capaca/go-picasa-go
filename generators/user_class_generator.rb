class UserClassGenerator
  include Singleton
  
  def generate file_name, picasa_id, password
    file_name = underscore file_name
    class_name = camelize file_name
    auth_token = Picasa::Authentication.authenticate picasa_id, password
    create_file file_name, class_name, auth_token
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
  
  def create_file file_name, class_name, auth_token
    file = File.new "#{file_name}.rb", 'w'

    file_body = %{class #{class_name}
      acts_as_picasa_user
      
      def picasa_id
        \"#{picasa_id}\"
      end
      
      def auth_token
        \"#{auth_token}\"
      end
    end}

    file.write file_body
    file.close
  end
end

file_name = underscore(ARGV[0]) 
picasa_id = ARGV[1]
password = ARGV[2]
class_name = camelize file_name
auth_token = Picasa::Authentication.authenticate picasa_id, password
 


