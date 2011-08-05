require "rspec"
require "spec_helper"


describe "create_destination_file" do
  it "should create a nice path" do
    task = ExDownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp, destination:"synch_test", :filters=>[FileTypePredicate.new('txt')])

    new_file  =  task.create_destination_file_name "2011072900_foretak.txt"
    expected_file_name = "/Users/birger/synch_test/2011/07-29/foretak.txt"

    (new_file.eql? expected_file_name ).should == true

  end
end