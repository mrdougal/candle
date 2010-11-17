

module Candle
  
  require 'candle/candle'
  
  class Base

    attr_accessor :path
    
    
    # Requires a path to passed in
    # so we know what file to retrieve information from
    def initialize(path)

      raise ArgumentError, 'Path is nil' if path.nil?
      @path = path
    end
    
    # Returns a hash of attributes from Spotlight
    def metadata
      @metadata ||= get_raw_metadata
    end
    
    # Raise an exception if an attempt to write metadata was made
    # as this isn't currently supported
    def metadata=(*args)
      raise "Writing metadata is not supported"
    end
    
    private
    
    # Does the 'actual' work and asks spotlight for the metadata
    def get_raw_metadata
      Spotlight.attributes @path
    end

  end

end