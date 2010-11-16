require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Candle" do
  
  
  shared_examples_for 'common metadata' do
    
    before(:each) do
      @metadata = @item.metadata
    end
    
    
    it "should return a hash" do
      @metadata.should respond_to(:keys)
    end
  
    it "should not be empty" do
      @metadata.should_not be_empty
    end
    
    it "should have a content_type_tree" do
      @metadata[:content_type_tree].should_not be_empty
    end
    
    
  end
  
  describe "images" do
    
    
    shared_examples_for 'common bitmap' do
      
      it "should be an image" do
        @item.should be_image
      end
      
      it "should be a bitmap" do
        @item.should be_bitmap
      end
      
      it "should have width" do
        @item.metadata[:pixel_width].should_not be_nil
      end
    
      it "should have height" do
        @item.metadata[:pixel_height].should_not be_nil
      end
      
    end
    
    
    shared_examples_for 'common composite' do

      it "should be an image" do
        @item.should be_image
      end
      
      it "should be a composite" do
        @item.should be_composite
      end
      
    end
    
    describe "bitmaps" do
      
      %w'gif jpg png psd'.each do |img|

        describe "example.#{img}" do
      
          before(:each) do
    
            file_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/images/example.#{img}")
    
            @file = File.open file_path
            @item = Candle::Base.new(@file.path)
          end
      
        
          it_should_behave_like 'common metadata'
          it_should_behave_like 'common bitmap'
          
      
        end
      end
    end
    
    
    describe "composites" do
      
      %w'ai ps pdf'.each do |comp|
        
        describe "example.#{comp}" do
    
          before(:each) do
  
            file_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/composites/example.#{comp}")
  
            @file = File.open file_path
            @item = Candle::Base.new(@file.path)
          end
    
          it "should have a creator" do
            @item.metadata[:creator].should_not be_nil
          end
          
          it_should_behave_like 'common metadata'
          it_should_behave_like 'common composite'
          
        
        end
      end
    end
    
  end
  

end
