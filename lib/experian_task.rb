require_relative "task"
  class ExperianTask < Task

  def initialize(param)
    super(param)
  end

  def create_destination_file_name(file_name)

    date = file_name.split('_').first
          year = date[0..3]
          month = date[4..5]
          day = date [6..7]
          name = file_name.split('_').last

    @destination + "/#{year}/#{month}-#{day}/#{name}"
  end
end