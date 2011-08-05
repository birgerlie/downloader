require "rspec"
require "spec_helper"

describe SFtpWorker do

  it "should return 1 or more files" do
    worker = SFtpWorker.new({:host=>'80.232.16.151', user:'cbook', password:'INfigr4'})
    worker.list.length.should > 1

  end


end

describe "list_new_files" do

  it "should return files newer than a specific date" do

    time1 = Time.new(2010,1,1,1,1,1,1)
    time2 = Time.new(2030,1,1,1,1,1,1)

    worker = SFtpWorker.new({:host=>'80.232.16.151', user:'cbook', password:'INfigr4'})
    worker.list_new_files(time1).length.should > 1
    worker.list_new_files(time2).length.should == 0

  end
end