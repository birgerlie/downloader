require "rspec"
require_relative "spec_helper"

describe "list_parse" do

  it "should return a list" do
    hdfs = Hdfs.new()
    list = "Found 3 items\ndrwxr-xr-x   - birger supergroup          0 2011-05-27 16:55 /user/birger/conf\ndrwxr-xr-x   - birger supergroup          0 2011-06-23 09:50 /user/birger/experian\n-rw-r--r--   3 birger supergroup   27395244 2011-06-28 13:49 /user/birger/web-indexing-1.0-SNAPSHOT-job.jar\n"
    (hdfs.parse_list(list).is_a? Array).should == true
  end
  it "should return a list with 3 hashes" do
    hdfs = Hdfs.new()
    list = "Found 3 items\ndrwxr-xr-x   - birger supergroup          0 2011-05-27 16:55 /user/birger/conf\ndrwxr-xr-x   - birger supergroup          0 2011-06-23 09:50 /user/birger/experian\n-rw-r--r--   3 birger supergroup   27395244 2011-06-28 13:49 /user/birger/web-indexing-1.0-SNAPSHOT-job.jar\n"
    hdfs.parse_list(list).length.should == 3
  end

  it "files should have a :name property" do
    hdfs = Hdfs.new()
    list = "Found 3 items\ndrwxr-xr-x   - birger supergroup          0 2011-05-27 16:55 /user/birger/conf\ndrwxr-xr-x   - birger supergroup          0 2011-06-23 09:50 /user/birger/experian\n-rw-r--r--   3 birger supergroup   27395244 2011-06-28 13:49 /user/birger/web-indexing-1.0-SNAPSHOT-job.jar\n"
    hdfs.parse_list(list).each {|f| (f[:name].is_a? String )== true}
  end

  it "files should have a :last_modified property" do
      hdfs = Hdfs.new()
      list = "Found 3 items\ndrwxr-xr-x   - birger supergroup          0 2011-05-27 16:55 /user/birger/conf\ndrwxr-xr-x   - birger supergroup          0 2011-06-23 09:50 /user/birger/experian\n-rw-r--r--   3 birger supergroup   27395244 2011-06-28 13:49 /user/birger/web-indexing-1.0-SNAPSHOT-job.jar\n"
      hdfs.parse_list(list).each {|f| (f[:last_modified] < Time.now) == true}
  end

  it ":last_modified should be parsed correct" do
      hdfs = Hdfs.new()
      list = "drwxr-xr-x   - hjellum supergroup          0 2011-06-17 08:20 /user/hjellum/social_media"

      last_mod =  hdfs.parse_list(list).last[:last_modified]
      actual =  Time.utc(2011,6,17, 8 ,20)

      last_mod.should == actual
  end

  it "files should parse :size" do
      hdfs = Hdfs.new()
      list = "drwxr-xr-x   - hjellum supergroup          1123 2011-06-17 08:20 /user/hjellum/social_media"
      value =  hdfs.parse_list(list).first[:size]
      value.should == 1123
  end

  it "files should contain file name as :name" do
      hdfs = Hdfs.new()
      list = "drwxr-xr-x   - hjellum supergroup          1123 2011-06-17 08:20 /user/hjellum/social_media"
      value =  hdfs.parse_list(list).first
      value[:name].should == "/user/hjellum/social_media"
      end

  it "files should not match a plain string" do
      hdfs = Hdfs.new()
      list = "Found tree files   1123 2011-06-17 08:20 /user/hjellum/social_media"
      value =  hdfs.parse_list(list)
      value.length.should == 0
      end


  it "should write data to hdfs" do
    hdfs = Hdfs.new()
    hdfs.

  end

end