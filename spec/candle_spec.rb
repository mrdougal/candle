require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Candle" do
  
  
  describe "indexed assets" do
  
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
    
  
    %w'ai eps gif jpg pdf png ps svg'.each do |img|

      describe "example.#{img}" do
    
        before(:each) do
  
          file_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/example.#{img}")
  
          @file = File.open file_path
          @item = Candle::Base.new(@file.path)
        end
    
        it_should_behave_like 'common metadata'
    
      end
      
    end
  end


  # Assets aren't guaranteed to be indexed by Spotlight
  # eg: files within hidden directories aren't indexed
  describe "non-indexed asset" do
    
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/.hidden/example.psd")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end
    
    it "shouldn't be indexed" do
      @item.should_not be_indexed
    end
    
  end
  
  
  describe "empty files" do
    
    before(:each) do

      file_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/empty-file")

      @file = File.open file_path
      @item = Candle::Base.new(@file.path)
    end

    it "shouldn't be indexed" do
      @item.should_not be_indexed
    end
    
  end

end
