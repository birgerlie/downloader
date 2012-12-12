require_relative "task"
require 'zip/zip'


class DNBTask < Task

  def create_destination_file_name(file_name)
    now = Time.new
    @destination + "/#{now.year}/#{now.month}-#{now.day}/#{file_name}"
  end
end