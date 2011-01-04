# encoding: UTF-8


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Composite assets" do
  
  
  before(:each) do
    @basepath = File.expand_path(File.dirname(__FILE__) + "/../fixtures/bitmaps")
  end
  
  
  
  describe "PNG Image" do
    
    before(:each) do

      file_path = File.join(@basepath , "example.png")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'
    
    it "should say it's kind is Portable Network Graphics" do
      @item.metadata['kMDItemKind'].should =~ /Portable Network Graphics/
    end
    
  end  
  
  
  describe "JPEG Image" do
    
    before(:each) do

      file_path = File.join(@basepath , "example.jpg")


      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'
    
    it "should say it's kind is JPEG" do
      @item.metadata['kMDItemKind'].should =~ /JPEG/
    end
    
  end
  
  
  describe "GIF Image" do
    
    before(:each) do

      file_path = File.join(@basepath , "example.gif")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'
    
    it "should say it's kind is Graphics Interchange Format" do
      @item.metadata['kMDItemKind'].should =~ /Graphics Interchange Format/
    end
    
  end
  
 
  
  
end