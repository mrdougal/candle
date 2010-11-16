module Candle::Image

  module ClassMethods
    
  end

  module InstanceMethods

    # Is the file an image?
    def image?

      true
      # attributes['kMDItemContentTypeTree'].member? 'image'
      # self.content_type_tree =~ /image/
    end

  end


  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

end
