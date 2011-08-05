require "rspec"
require "spec_helper"


describe 'find_new_or_modified_files' do
  it "should return emtpy array if arrays are equal" do

    t = Time.now

    external_files = [{ :name=>"foo", size: 0, last_modified: t}, { :name=>"foo1", size: 0, last_modified: t}, { :name=>"foo2", size: 0, last_modified: t}]
    internal_files1 = [{ :name=>"foo", size: 1, last_modified: t}, { :name=>"foo1", size: 0, last_modified: t}, { :name=>"foo2", size: 0, last_modified: t}]
    internal_files2 = [{ :name=>"foo", size: 0, last_modified: t}, { :name=>"bar", size: 0, last_modified: t}, { :name=>"bar2", size: 0, last_modified: t}]

    d = Downloader.new
    d.find_new_or_modified_files(external_files, external_files).should == []
  end

  it "should return array with 1 element" do
    t = Time.now
    external_files = [{ :name=>"foo", size: 2, last_modified: t}, { :name=>"foo1", size: 0, last_modified: t}, { :name=>"foo2", size: 0, last_modified: t}]
    internal_files1 = [{ :name=>"foo", size: 1, last_modified: t}, { :name=>"foo1", size: 0, last_modified: t}, { :name=>"foo2", size: 0, last_modified: t}]

    d = Downloader.new
    d.find_new_or_modified_files(external_files, internal_files1).should == [{ :name=>"foo", size: 2, last_modified: t}]
    pp d.list
  end
end

describe "compare_file" do
  it "should compare two maps with :size and :last_modified" do
    d = Downloader.new
    t = Time.now
    local = { :name=>"foo", size: 0, last_modified: t }
    remote = { :name=>"foo", size: 0, last_modified: t }


    d.compare_file(local, remote).should == false
  end

  it "should return false if :size is different" do
    d = Downloader.new
    t = Time.now
    local = { :name=>"foo", size: 0, last_modified: t }
    remote = { :name=>"foo", size: 1, last_modified: t }


    d.compare_file(local, remote).should == false
  end

  it "should return false if local:last_modified is less than remote" do
    d = Downloader.new
    t1 = Time.now
    t2 = Time.now

    local = { :name=>"foo", size: 1, last_modified: t1 }
    remote = { :name=>"foo", size: 1, last_modified: t2 }


    d.compare_file(local, remote).should == false
  end

  it "should return true if local:last_modified is larger than remote" do
    d = Downloader.new
    t1 = Time.now
    t2 = Time.now

    local = { :name=>"foo", size: 1, last_modified: t2 }
    remote = { :name=>"foo", size: 1, last_modified: t1 }
    d.compare_file(local, remote).should == true
  end

  it "should return false if local or remote is missing :size or :last_modified" do
    d = Downloader.new
    t1 = Time.now
    t2 = Time.now

    local = { :name=>"foo", size: 1, last_modified: t2 }
    remote = { :name=>"foo", size: 1, last_modified: t1 }
    d.compare_file({ }, remote).should == false
    d.compare_file(local, { }).should == false
     d.compare_file(local, nil).should == false
  end


end