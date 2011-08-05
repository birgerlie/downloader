require "rspec"
require "spec_helper"

describe "create_worker" do
  it "should return a worker" do
    task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp)
    task.create_worker.should_not == nil
  end

  it "should raise exceptions if connection params is incorrect" do

  end



end

describe "get_local_files" do
  it "should return an array" do
     task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp )
      (task.get_local_files.is_a? Array).should == true
  end

  it "should return 1 or more files" do
     task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp )
      task.get_local_files.length > 0
  end

  it "files should have size and last_modified and a file name" do
     task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp )
     task.get_local_files.first[:size].should > 0
     task.get_local_files.first[:name].length.should > 0
     task.get_local_files.first[:last_modified].should > 0
  end
end


describe "get_remote_files" do
 it "should return an array" do
     task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp )
      (task.get_remote_files.is_a? Array).should == true
  end

  it "should return 1 or more files" do
     task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp )
      task.get_remote_files.length > 0
  end

  it "files should have size and last_modified and a file name" do
     task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp )
     remote_files =  task.get_remote_files

     pp remote_files.first

     remote_files.first[:size].should > 0
     remote_files.first[:name].length.should > 0
     (remote_files.first[:last_modified] < Time.now).should == true
  end

  it "files should filter by filetype" do
    fp = FileTypePredicate.new("txt")
    task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp, filter: [fp])
    task.get_remote_files.each {|f|  fp.match(f).should == true   }
  end

  it "files should filter by filetype" do
    fp = FileTypePredicate.new("txt")
    rp = RegexPredicate.new(/foretak/)
    task = DownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp, filter: [fp,rp])
    task.get_remote_files.each {|f|  fp.match(f).should == true }
    task.get_remote_files.each {|f|  fp.match(f).should == true and rp.match(f).should == true  }
  end

end