require_relative "worker"
require 'net/ssh'
require 'net/sftp'



class SFtpWorker < Worker

  def initialize(params = { })
    super(params)

    @host =  params.delete(:host)
    @user = params.delete(:user)

#    raise "user required" unless @user
    raise "host required" unless @host
  end

  def list(dir = '')
    sftp = Net::SFTP.start(@host,@user ,@params )

    files = []
      sftp.dir.foreach("") do |entry|
        if(entry.longname.start_with?"-")
          files << {:name=>entry.name, size: entry.attributes.size, last_modified: Time.at(entry.attributes.mtime)}
        end
      end


    files
  end

  def get(source, destination)
    ftp = Net::SFTP.start(@host,@user ,@params )
    ftp.download!(source, destination)
  end

end