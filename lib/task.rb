require_relative "../lib/ftp_worker"
require_relative "../lib/s_ftp_worker"
require_relative "../lib/hdfs"

require "pp"


class Task
  attr_accessor :username, :password, :host, :destination, :protocol, :last_check, :filter, :source

  TEMP_FILE_DIR ="temp_files"

  def initialize(param)
    @protocol = param[:protocol] || :ftp
    @username = param[:user] ||'anonymous'
    @password = param[:password] ||""
    @host= param[:host]
    raise "host emp ty" unless @host
    @host= param[:host]
    @destination = param[:destination] || Dir.home
    @source= param[:source] || ""
    @filters = param[:filters] || []


    Dir.mkdir(TEMP_FILE_DIR) unless Dir.exist? TEMP_FILE_DIR


  end

  def create_worker
    connection_params = {
        user: @username,
        password: @password,
        host: @host
    }
    if (@protocol == :sftp)
      return SFtpWorker.new(connection_params)
    end

    if (@protocol == :ftp)
      return FtpWorker.new(connection_params)
    end

    raise "unsuported protocol exception"
  end

  def filter(files)
    return files if @filters.length == 0

    filtered =[]

    files.each do |file|
      num_filters = @filters.length
      for filter in @filters
        if filter.match(file)
          num_filters -=1
        else
          break
        end
        filtered << file if num_filters == 0
      end
    end
    filtered
  end

  def get_remote_files
    worker = create_worker

    if @source and worker.respond_to? :change_dir
      pp "setting dir to #{@source}"
      worker.change_dir @source
    end

    filter(worker.list)
  end

  def get_local_files
    local_files = []
    pp "setting local dir #{@destination}"
    local_files = Hdfs.new().list_recursive(@destination)
    filter(local_files)
  end

  def create_destination_file_name(file)
    @destination + "/" + file
  end

  def download_external_files(files = [])

    worker = create_worker
    if @source and worker.respond_to? :change_dir
      pp "setting dir to #{@source}"
      worker.change_dir @source
    end

    sum_bytes = 0
    sum_sec = 1
    files.each do |file|
      file_name = file[:name]

      start = Time.now

      pp "downloading #{file_name}  #{file[:size]/1024}"

      worker.get(file_name, file_name)

      diff = Time.now - start

      bs = file[:size]/diff
      sum_bytes += (file[:size]/1024)
      sum_sec += diff

      pp "downloaded #{file_name}  in #{diff} s #{bs/1024} "

      new_file_name = create_destination_file_name file_name
      write_file_to_hdfs(file_name, new_file_name)
    end

    pp "downloaded #{files.length} files, total #{sum_bytes/1024} Mb in #{sum_sec} sec avg #{sum_bytes/sum_sec}"
    files
  end

  def write_file_to_hdfs(source, destination)\
      file = ""
    if file.downcase.end_with? "zip"
      unzip_file(source, Dir.current)
    end

    Hdfs.new().put(source, destination)
    File.delete(source)
  end

  def unzip_file (file, destination)
    #Zip::ZipFile.open(file) { |zip_file|
    #  zip_file.each { |f|
    #    f_path=File.join(destination, f.name)
    #    FileUtils.mkdir_p(File.dirname(f_path))
    #    zip_file.extract(f, f_path) unless File.exist?(f_path)
    #  }
    #}
  end
end