require_relative "worker"
require  "net/ftp"
require  "net/ftp/list"

class FtpWorker   < Worker
  def initialize(params = {})
    super(params)

    @ftp = Net::FTP.new(host=params[:host],user=params[:user],passwd=params[:password])
    begin
      @ftp.login
    rescue Exception =>e
      pp e
    end

  end

  def list(dir= '')
    change_dir(dir) unless dir== ''

    files = []
    @ftp.list.each do |file|
      info =  Net::FTP::List.parse(file)
      if(info.file? and !info.name.start_with? "." and !info.symlink?)
        files << {:name=>info.name, size: info.size, last_modified: info.mtime}
      end
    end

    files
  end

  def get(source, destination)
    @ftp.getbinaryfile(source,destination)
  end

  def change_dir(dir)
     @ftp.chdir dir
  end
end