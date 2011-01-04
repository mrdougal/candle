# encoding: UTF-8

module Candle
  
  class Base

    # The path to the asset that we wish to retrieve metadata from
    attr_accessor :path
  
  
    # Requires a path, will raise an error if none is passed
    def initialize(path)

      raise ArgumentError, 'Path is nil' if path.nil?
      @path = path
    end
  
    # Returns a hash of attributes from Spotlight
    def metadata
      # @metadata ||= 
      get_raw_metadata
    end
  
    # Raise an exception if an attempt to write metadata was made
    # as this isn't currently supported
    def metadata=(*args)
      raise "Writing metadata is not supported"
    end
  
    # If an item hasn't been indexed there is no content type tree
    # Therefore this method checks for the presense of a content type tree
    # kMDItemContentTypeTree
    def indexed?
      !!metadata['kMDItemContentTypeTree']
    end
  
    private
  
    # Does the 'actual' work and asks spotlight for the metadata
    def get_raw_metadata
      
      md = Candle::Spotlight.attributes @path
      
      
      # Convert all of the strings in the hash to utf-8
      md.each_pair do |key, value|
        
        next unless value.respond_to?(:encode)

        
        # We need to force the encoding of the string
        # even though we should have utf8 strings returned via Spotlight
        utf8_str = value.force_encoding("utf-8")
        

        # Unfortunately rubys string method "valid_encoding?" doesn't raise 
        # doesn't pick up on invalid byte_sequences
        # 
        # Therefore the encoding may still be off
         # so we'll convert again but replace the invalid chars
        utf8_str.encode!("utf-8", :undef => :replace, 
                                  :invalid => :replace, 
                                  :replace => "x" ) 
                                  
          
        # end
        
        
        md[key] = utf8_str
        
      end
      
      md
      
    end
    
    
    
  end

end
