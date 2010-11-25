module Picasa::Util
  
  def extract_auth_token body
    body[/Auth=(.*)/, 1]
  end
  
  def extract_auth_sub_token body
    body[/Token=(.*)/, 1]
  end
  
  def self.generate_authorization_header token_hash
    if token_hash and token_hash.length > 0
      if token_hash[:sub_token]
        return {"Authorization" => "AuthSub token=#{token_hash[:sub_token]}"}
      elsif token_hash[:auth_key]
        return {"Authorization" => "GoogleLogin auth=#{token_hash[:auth_key]}"}
      end
    end
    nil
  end
  
  def raise_exception?
    begin
      yield
    rescue
      return false
    end
    true
  end
  
  def define_dependent_class_method method_name, class_name
    define_method method_name do
      eval(class_name)
    end
  end
  
  def define_static_dependent_class_method method_name, class_name
    (class << self; self; end).instance_eval { 
      define_dependent_class_method method_name, class_name
    }
  end
  
  def define_dependent_class_methods method_name, class_name
    define_dependent_class_method method_name, class_name
    define_static_dependent_class_method method_name, class_name
  end
  
end
