# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe "Package assets" do


  
  before(:each) do
    @basepath = File.expand_path(File.dirname(__FILE__) + "/../fixtures/packages")
  end

  describe "iWork" do


    # As a curiosity, iWork docs have empty attributes in their metadata
    # this has cause issues in the page
    

    describe "numbers document" do

      before(:each) do

        file_path = File.join(@basepath, "example.numbers")

        @file = File.open file_path
        @item = Candle::Base.new(@file.path)
      end

      it_should_behave_like 'common metadata'

      it "should say it's kind is Graphics Interchange Format" do
        @item.metadata['kMDItemKind'].should =~ /Numbers/
      end

    end


    describe "pages document" do

      before(:each) do

        file_path = File.join(@basepath, "example.pages")

        @file = File.open file_path
        @item = Candle::Base.new(@file.path)
      end

      it_should_behave_like 'common metadata'

      it "should say it's kind is Graphics Interchange Format" do
        @item.metadata['kMDItemKind'].should =~ /Pages/
      end

    end

    describe "keynote document" do

      before(:each) do

        file_path = File.join(@basepath, "example.key")

        @file = File.open file_path
        @item = Candle::Base.new(@file.path)
      end

      it_should_behave_like 'common metadata'

      it "should say it's kind is Graphics Interchange Format" do
        @item.metadata['kMDItemKind'].should =~ /Keynote/
      end

    end

  end


end