# encoding: UTF-8

# Integers and Floats are/were being mashed coming back from C
# eg: We are getting 140733193388034 pages from a 2 page pdf


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Videos" do
  
  

  describe "Quicktime" do

    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/videos/example.mov")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "should say it's duration is ~3.5 seconds (Float)" do
      @item.metadata['kMDItemDurationSeconds'].should be_within(0.1).of(3.5)
    end
    
  end
  
end