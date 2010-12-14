# encoding: UTF-8

# Integers and Floats are/were being mashed coming back from C
# eg: We are getting 140733193388034 pages from a 2 page pdf


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Numbers in assets" do
  
  
  describe "Two page pdf" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.pdf")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should have 2 pages (Fixnum)" do
      @item.metadata['kMDItemNumberOfPages'].should == 2
    end
    
    it "should have a page height of ~283 (Float)" do
      @item.metadata['kMDItemPageHeight'].should be_within(10).of(280)
    end

    it "should have a page width of ~425 (Float)" do
      @item.metadata['kMDItemPageWidth'].should be_within(10).of(425)
    end
    
    it "should be ~250k in size (Fixnum)" do
      @item.metadata['kMDItemFSSize'].should be_within(1000).of(250000)
    end

  end
  
  describe "Illustator document" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.ai")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should say it's size is ~1.1Mb" do
      @item.metadata['kMDItemFSSize'].should be_within(1000000).of(100000)
    end
    
  end
  
  describe "Video" do
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.mov")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should say it's duration is ~3.5 seconds (Float)" do
      @item.metadata['kMDItemDurationSeconds'].should be_within(0.1).of(3.5)
    end
    
  end
  
end