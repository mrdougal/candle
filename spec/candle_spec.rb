require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Candle" do
  
  before(:each) do
    @item = Candle::MDItemNative.new(__FILE__)
    @filename = File.basename(__FILE__)
  end
  
  it "should instanciate" do
    @item.should be_an_instance_of Candle::MDItemNative
  end
  
  describe "attribute names" do
    
    before(:each) do
      @attributes = @item.attribute_names  
    end
    
    it "should return an array" do
      @attributes.should respond_to(:size)
    end
    
    it "should include ItemKind" do
      @attributes.should be_include('kMDItemContentTypeTree')
    end
    
  end
  
  
end
