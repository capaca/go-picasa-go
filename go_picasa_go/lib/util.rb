module Picasa::Util
  
  def act_as_picasa_user
    include Picasa::User
  end
  
  def act_as_picasa_album
    include Picasa::Album
  end
  
  def act_as_picasa_photo
    include Picasa::Photo
  end
  
  def extract_auth_token body
    body[/Auth=(.*)/, 1]
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
