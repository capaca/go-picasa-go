module Picasa::Missing
  def method_missing(method, *args, &block)
    case method
      when :save
        self.send(:picasa_save)
      when :save!
        self.send(:picasa_save!)
      when :update
        self.send(:picasa_update)
      when :update!
        self.send(:picasa_update!)
      when :update_attributes
        self.send(:picasa_update_attributes, args)
      when :update_attributes!
        self.send(:picasa_update_attributes!, args)
      when :destroy
        self.send(:picasa_destroy)
      when :destroy!
        self.send(:picasa_destroy!)
    end
  end
end
