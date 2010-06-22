require 'spec/spec_helper'

describe Candle do

  describe "Images" do

    describe "base attributes", :shared => true do
      
      it "should be an image" do
        @item.should be_image
      end
    
      it "should have a kind" do
        @item.kind.should_not be_empty
      end
      
      it "should have a content type" do
        @item.content_type.should_not be_empty
      end
    end

    describe "jpg" do
      
      before(:each) do

        file_path = File.expand_path(File.dirname(__FILE__) + '/../fixtures/images/example.jpg')

        @file = File.open file_path
        @item = Candle.new(@file.path)
      end
      
      it_should_behave_like 'base attributes'
      
      describe "kind" do
        
        it "should mention 'Portable Document Format'" do
          @item.kind.should =~ /Portable Document Format/
        end

        it "should mention '(pdf)'" do
          @item.kind.should =~ /(pdf)/i
        end
      end

      describe "content type" do
        
        it "should mention adobe.pdf" do
          @item.content_type.should =~ /adobe.pdf/
        end
        
        ['content', 'composite-content','pdf'].each do |attribute|
          it "should contain #{attribute}" do
            @item.content_type_tree.should be_member(attribute)
          end
        end
      end

    end
    
    describe "png" do
      
      before(:each) do

        file_path = File.expand_path(File.dirname(__FILE__) + '/../fixtures/images/example.png')

        @file = File.open file_path
        @item = Candle.new(@file.path)
      end
      
      it_should_behave_like 'base attributes'
      
      describe "kind" do
        
        it "should mention 'Portable Network Graphics'" do
          @item.kind.should =~ /Portable Network Graphics/
        end

        it "should mention 'image'" do
          @item.kind.should =~ /image/i
        end
      end

      describe "content type" do
        
        it "should mention png" do
          @item.content_type.should =~ /png/
        end
        
        ['png','image','content'].each do |attribute|
          it "should contain #{attribute}" do
            @item.content_type_tree.should be_member(attribute)
          end
        end
      end

    end
    
    describe "psd" do
      
      before(:each) do

        file_path = File.expand_path(File.dirname(__FILE__) + '/../fixtures/images/example.psd')

        @file = File.open file_path
        @item = Candle.new(@file.path)
      end
      
      it_should_behave_like 'base attributes'
      
      describe "kind" do
        
        it "should == 'Adobe Photoshop file'" do
          @item.kind.should == 'Adobe Photoshop file'
        end

        it "should mention 'photoshop'" do
          @item.kind.should =~ /photoshop/i
        end
      end

      describe "content type" do
        
        it "should mention photoshop-image" do
          @item.content_type.should =~ /photoshop-image/
        end
        
        ['photoshop-image','image','content'].each do |attribute|
          it "should contain #{attribute}" do
            @item.content_type_tree.should be_member(attribute)
          end
        end
      end

    end
    
    
    
    
    

      
      
  end
end
