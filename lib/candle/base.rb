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
      @metadata ||= get_raw_metadata
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
      
      Candle::Spotlight.attributes @path
    end

  end

end
