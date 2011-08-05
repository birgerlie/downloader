require_relative "lib/downloader"
require_relative "lib/ex_download_task"
require_relative "lib/file_type_predicate"
require_relative "lib/download_task"


class FtpSynch

  def initialize()
    Downloader.new({tasks: [

        ExDownloadTask.new(:host=>'80.232.16.151', user:'cbook', password:'INfigr4', :protocol=> :sftp, destination:"/user/hjellum/file_transfer/experian", :filters=>[FileTypePredicate.new('txt')]),
        DownloadTask.new(:host =>"ftp.dnb.com" , user:'compnybk', password:'zhtmap29', :protocol=> :ftp, :destination=>"/user/hjellum/file_transfer/dnb" , :source=>'/gets')]})
  end

end

FtpSynch.new