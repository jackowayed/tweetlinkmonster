require File.join( File.dirname(__FILE__), '..', "spec_helper" )
include Merb::GlobalHelpers

describe Merb::GlobalHelpers, "#webpage_title" do
  it "should return nil if given something without a <title>" do
    webpage_title("foobar!!!").should == "Title Not Found"
  end
  it "should return the title of a page that does have a title" do
    webpage_title("<title>Hello World!</title>").should == "Hello World!"
  end
end

