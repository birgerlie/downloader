require "rspec"
require "spec_helper"

describe Data do

  it "should list files" do
    list = FtpWorker.new({:host=>'ftp.uio.no'}).list
    list.length.should > 0

  end

  it "list files should contain welcome.msg" do
    list = FtpWorker.new({:host=>'ftp.uio.no'}).list

  end

end

describe "list_new_files" do

  it "should return files newer than a specific date" do

    time1 = Time.new(2010,1,1,1,1,1,1)
    time2 = Time.new(2030,1,1,1,1,1,1)

    worker = FtpWorker.new({:host=>'ftp.uio.no'})
    worker.list_new_files(time1).length.should > 0
    worker.list_new_files(time2).length.should == 0
  end

end
