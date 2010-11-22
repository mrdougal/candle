# encoding: UTF-8

# Smaller strings are being returned as Integers
# eg: kMDItemFSTypeCode is 1346651680 when it should be 'PDF'


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Strings in assets" do
  
  
  describe "Two page pdf" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.pdf")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should have it's display name as 'example.pdf'" do
      @item.metadata['kMDItemDisplayName'].should == "example.pdf"
    end
    
    it "should say it's name is example.pdf" do
      @item.metadata['kMDItemFSName'].should == 'example.pdf'
    end

    it "should say it's kind is PDF" do
      @item.metadata['kMDItemKind'].should =~ /Portable Document Format/
    end
     
     
  end
  
  describe "Illustator document" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.ai")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should have it's display name as 'example.ai'" do
      @item.metadata['kMDItemDisplayName'].should == "example.ai"
    end
    
    it "should contain Illustrator in it's kind" do
      @item.metadata['kMDItemKind'].should =~ /Illustrator/
    end
    
    
  end
  
  
end