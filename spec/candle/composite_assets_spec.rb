# encoding: UTF-8


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Composite assets" do
  
  before(:each) do
    @basepath = File.expand_path(File.dirname(__FILE__) + "/../fixtures/composite")
  end
  
  describe "Adobe Illustrator" do
    
    before(:each) do
      
      file_path = File.join(@basepath , "example.ai")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'
    
    it "should say it's kind contains Illustrator" do
      @item.metadata['kMDItemKind'].should =~ /Illustrator/
    end
    
    it "should contain illustrator in it's content type" do
      @item.metadata['kMDItemContentType'].should =~ /com.adobe.illustrator/
    end
    
    it "should say it's size is ~1.1Mb" do
      @item.metadata['kMDItemFSSize'].should be_within(1000000).of(100000)
    end
    
    it "should have it's display name as 'example.ai'" do
      @item.metadata['kMDItemDisplayName'].should == "example.ai"
    end
    
    it "should contain Illustrator in it's kind" do
      @item.metadata['kMDItemKind'].should =~ /Illustrator/
    end
    
    
    
  end
  

  describe "EPS" do
    
    before(:each) do

      file_path = File.join(@basepath , "example.eps")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'
    
    it "should say it's kind is Encapsulated PostScript" do
      @item.metadata['kMDItemKind'].should == 'Encapsulated PostScript'
    end
    
    it "should say it's content type is com.adobe.postscript" do
      @item.metadata['kMDItemContentType'].should == 'com.adobe.encapsulated-postscript'
    end
    

  end


  describe "PostScript" do
    
    before(:each) do

      file_path = File.join(@basepath , "example.ps")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'


    it "should say it's kind is PostScript" do
      @item.metadata['kMDItemKind'].should == 'PostScript'
    end
    
    it "should say it's content type is com.adobe.postscript" do
      @item.metadata['kMDItemContentType'].should == 'com.adobe.postscript'
    end
    

  end


  describe "Adobe PDF" do
    
    before(:each) do

      file_path = File.join(@basepath , "example.pdf")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'

    it "should say it's kind is PDF" do
      @item.metadata['kMDItemKind'].should == 'Portable Document Format (PDF)'
    end
    
    it "should have it's display name as 'example.pdf'" do
      @item.metadata['kMDItemDisplayName'].should == "example.pdf"
    end
    
    it "should say it's name is example.pdf" do
      @item.metadata['kMDItemFSName'].should == 'example.pdf'
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
  
  
  describe "SVG Image" do
    
    before(:each) do

      file_path = File.join(@basepath , "example.svg")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'
    
    it "should say it's kind is SVG Image" do
      @item.metadata['kMDItemKind'].should == 'SVG Image'
    end

  end
  

end
