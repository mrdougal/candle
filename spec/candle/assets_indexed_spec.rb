require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Composite assets" do
  
  

  shared_examples_for 'common metadata' do
  
    before(:each) do
      @metadata = @item.metadata
    end
    
    it "should be indexed" do
      @item.should be_indexed
    end
  
  
    it "should return a hash" do
      @metadata.should respond_to(:keys)
    end

    it "should not be empty" do
      @metadata.should_not be_empty
    end
  
    describe "content type tree" do
      
      before(:each) do
        @content_type_tree = @metadata['kMDItemContentTypeTree']  
      end
      
      it "should have one" do
        @content_type_tree.should_not be_empty
      end
      
      it "should have at least 3 members" do
        @content_type_tree.should have_at_least(3).things
      end
    end
  
  
  end


  describe "Adobe Illustrator" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.ai")

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
    
  end
  
  

  describe "EPS" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.eps")

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

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.ps")

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

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.pdf")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'

    it "should say it's kind is PDF" do
      @item.metadata['kMDItemKind'].should == 'Portable Document Format (PDF)'
    end


  end
  
  
  describe "SVG Image" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.svg")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'
    
    it "should say it's kind is SVG Image" do
      @item.metadata['kMDItemKind'].should == 'SVG Image'
    end

  end
  
  describe "SVG Image" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.png")

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

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.jpg")

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

      file_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/example.gif")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it_should_behave_like 'common metadata'
    
    it "should say it's kind is Graphics Interchange Format" do
      @item.metadata['kMDItemKind'].should =~ /Graphics Interchange Format/
    end
    
  end
  

end
