require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Candle" do
  
  before(:each) do
    
    file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/images/example.jpg')
    
    @file = File.open file_path
    @item = Candle.new(@file.path)

  end
  
  it "should instanciate" do
    @item.should be_an_instance_of Candle::MDItemNative
  end
  
  describe "attributes" do
    it "should return a hash" do
      @item.attributes.should respond_to(:keys)
    end
  end
  
  describe "attribute names" do
    
    before(:each) do
      @attributes = @item.attribute_names  
    end
    
    it "should return an array" do
      @attributes.should respond_to(:size)
    end
  end
  
  
end
