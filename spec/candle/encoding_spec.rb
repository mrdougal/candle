# encoding: UTF-8


# Some assets have ut8 characters in their metadata
# we need to make sure that we are handling this correctly


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Assets with unicode characters in their metadata" do
  
  describe "Windings" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/wingdings.ttf")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should have © in it's copyright notice" do
      @item.metadata['kMDItemCopyright'].should =~ /©/
    end
    
  end
  
end


describe "Assets with unicode characters in their filename" do
  
  describe "éxample.txt" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/éxample.txt")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    
    it "should return a utf-8 string" do
      @item.metadata.keys.each do |k|
        @item.metadata[k].encoding.name.should == "UTF-8" if @item.metadata[k].is_a?(String)
      end
    end
    
    it "should have éxample in it's name" do
      @item.metadata['kMDItemDisplayName'].should == "éxample.txt"
    end
    
  end
  
end
