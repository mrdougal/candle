# encoding: UTF-8


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')



describe "Documents with nil attributes" do

  describe "numbers 08 document" do

    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/iWork/example-08.numbers")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    # it_should_behave_like 'common metadata'

    it "should say it's kind is Graphics Interchange Format" do
      @item.metadata['kMDItemKind'].should =~ /Graphics Interchange Format/
    end

  end


  describe "numbers 09 document" do

    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/iWork/example.numbers")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    # it_should_behave_like 'common metadata'

    it "should say it's kind is Graphics Interchange Format" do
      @item.metadata['kMDItemKind'].should =~ /Graphics Interchange Format/
    end

  end

end


