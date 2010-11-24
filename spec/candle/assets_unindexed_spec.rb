# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


# Assets aren't guaranteed to be indexed by Spotlight
# eg: files within hidden directories aren't indexed
describe "non-indexed asset" do
  
  
  before(:each) do

    file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/.hidden/example.psd")

    @file = File.open file_path
    @item = Candle::Base.new(@file.path)
  end
  
  it "shouldn't be indexed" do
    @item.should_not be_indexed
  end
  
end


describe "empty files" do
  
  before(:each) do

    file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/empty-file")

    @file = File.open file_path
    @item = Candle::Base.new(@file.path)
  end

  it "shouldn't be indexed" do
    @item.should_not be_indexed
  end
  
end