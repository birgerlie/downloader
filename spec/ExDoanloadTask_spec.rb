require "rspec"
require "spec_helper"


describe "create_destination_file" do
  it "should create a nice path" do

    task = ExDownloadTask.new(:host=>'ftp.uio.no', user:'anonumous', password:'', :protocol=> :ftp , destination:"synch_test", :filters=>[FileTypePredicate.new('txt')])

    new_file  =  task.create_destination_file_name "2011072900_foretak.txt"

    pp new_file

    expected_file_name = "synch_test/2011/07-29/foretak.txt"

    (new_file.eql? expected_file_name ).should == true

  end
end