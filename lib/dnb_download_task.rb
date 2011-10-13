require_relative "download_task"
require 'zip/zip'


class DNBDownloadTask < DownloadTask

  def create_destination_file_name(file_name)

    now = Time.new
    @destination + "/#{now.year}/#{now.month}-#{now.day}/#{file_name}"
  end
end