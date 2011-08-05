require "rspec"
require "spec_helper"
#require_relative "../lib/file_type_predicate"

describe "match" do

  it "should match file types" do
    fp = FileTypePredicate.new("txt")
    fp.match({:name=>"jalla.txt"}).should == true
  end

  it "should only match correct file types" do
    fp = FileTypePredicate.new("txt")
    fp.match({:name=>"jalla.bin"}).should == false
  end

end