

module Candle
  

  
  require 'candle/candle'
  require 'candle/image'
  
  # So that we can call underscore
  require 'active_support/inflector'
  
  class Base

    # VERSION = '0.0.1'
    
    attr_accessor :path
    attr_accessor :metadata
    
    def initialize(path)
      raise ArgumentError, 'Path is nil' if path.nil?

      self.path = path
      self.metadata = clean(raw_metadata)
    end
    
    def image?
      metadata[:content_type_tree].member? 'public.image'
    end
    
    
    def composite?
      
      puts metadata[:content_type_tree]
      metadata[:content_type_tree].member? 'public.composite-content'
    end
    
    def bitmap?
      !!metadata[:pixel_width]
    end
    
    
    private
    
    
    def raw_metadata
      @raw_metadata ||= Intern.attributes self.path
    end

    # We want to change the names of the attributes, so that they are more meaningful.
    # Additionally so that they are ruby-like. (being underscore and separated by underscores)
    # 
    # Will give us something like...
    # kMDItemContentModificationDate => content_modification_date
    # 
    def clean(md)

      out = {}
      
      md.each_pair do |key, value|
        
        new_key = key.gsub('kMDItem','').gsub('FS','').underscore
        out[new_key.to_sym] = md[key]
      end
        
      out
      
    end
    
    
  end

end