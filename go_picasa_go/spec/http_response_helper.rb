module Net
  class HTTPResponse
    SUCCESS_CODES = 200..206
    
    def success?
      SUCCESS_CODES.include? self.code.to_i
    end
    
    def message? msg
      self.message == msg
    end
    
    def method_missing(m, *args, &block)  
      m = m.to_s
      if m =~ /message_/
        msg = m.split("_")[1].gsub('?','')
        return message? msg
      else
        raise NoMethodError.new "undefined method #{m} for #{self.inspect}"
      end
    end  
  end
end
