$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'candle'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end





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


