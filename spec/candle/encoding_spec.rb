# encoding: UTF-8


# Some assets have ut8 characters in their metadata
# we need to make sure that we are handling this correctly


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Assets with unicode characters in their metadata" do
  
  describe "Windings" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/fonts/Wingdings.ttf")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should have © in it's copyright notice" do
      @item.metadata['kMDItemCopyright'].should =~ /©/
    end
    
  end
  
end


describe "Broken Assets" do
  
  describe "with poor unicode characters : Wingdings" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/corrupted/wingdings-broken.ttf")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should set the font as being bad" do
      @item.metadata["com_apple_ats_font_invalid"].should == 1
    end
    
  end
 
end


describe "Assets with unicode characters in their filename" do
  
  describe "éxample.txt" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/odd-filenames/éxample.txt")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    
    it "should return a utf-8 string for each metadata attribute" do

      @item.metadata.keys.each do |k|
        
        val = @item.metadata[k]
        val.encoding.name.should == "UTF-8" if val.is_a?(String)
      end
    end
    
    it "should have éxample in it's name" do
      @item.metadata['kMDItemDisplayName'].should == 'éxample.txt'
    end

    # it "should have éxample in it's name" do
    #   @item.metadata['kMDItemDisplayName'].to_s.encoding.name.should == 'éxample.txt'
    # end

    # it "should have éxample in it's name" do
    #   'éxample.txt'.should == 'éxample.txt'
    # end

    
  end
  
  describe "†est.txt" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/odd-filenames/†est.txt")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    
    it "should return a utf-8 string for each metadata attribute" do

      @item.metadata.keys.each do |k|
        
        val = @item.metadata[k]
        val.encoding.name.should == "UTF-8" if val.is_a?(String)
      end
    end
    
    # it "does something" do
    #   
    #   tmp = []
    #   @item.metadata.keys.each do |k|
    #     tmp << @item.metadata[k]
    #   end
    # 
    #   tmp.should == []
    # end
    
    it "should have †est in it's display name" do
      @item.metadata['kMDItemDisplayName'].should == '†est.txt'
    end
    
    it "should be able to display single byte chars" do
      @item.metadata['kMDItemKind'].should == 'Plain Text'
    end
    
  end
  
end
