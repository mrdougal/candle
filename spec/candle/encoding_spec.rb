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

    # it_should_behave_like 'common metadata'
    
    it "should have © in it's copyright notice" do
      @item.metadata['kMDItemCopyright'].should == "©"
    end
    
  end
  
end
