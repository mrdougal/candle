module Candle::Images

  def self.included(receiver)
    # receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  # module ClassMethods
  #   
  # end

  module InstanceMethods

    # Is the file an image?
    def image?
      self.kind =~ /image/
    end

  end

end
