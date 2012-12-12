require_relative "lib/downloader"
require_relative "lib/experian_task"
require_relative "lib/file_type_predicate"
require_relative "lib/task"


class FtpSynch

  def initialize()
    Downloader.new({tasks: [
        DownloadTask.new(:host =>"ftp.uio.no" , user:'anonymous', password:'', :protocol=> :ftp, :destination=>"/user/hjellum/file_transfer/dnb" , :source=>'/pub/rfc')]})
  end

end
FtpSynch.new
