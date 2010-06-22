class Candle
  
  def initialize(path)
    # Item = MDItemNative    
    puts path
  end
  
  # Returns a hash of attributes from spotlight
  def attributes
    {  }
  end
  

end




# require 'md_item_native'
require 'candle/images'

class Candle
  
  include Candle::Images

end