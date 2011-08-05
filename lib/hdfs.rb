require 'time'

class Hdfs
  PATTERN = /([drwx-]{10})\s*(-|\d+)\s*(\w+)\s(\w+)\s*(\d+)\s(\d{4}-\d{2}-\d{2})\s(\d{2}:\d{2})\s(.+)/

  def initialize


  end

  def list_recursive(dir = '/')
      cmd = "hadoop fs -lsr #{dir}"
    cmd_result = %x[#{cmd}]

    return parse_list cmd_result
  end

  def list(dir= "/")
    cmd = "hadoop fs -ls #{dir}"
    cmd_result = %x[#{cmd}]

    return parse_list cmd_result
  end

  def parse_list(list)
    files = []
    list.each_line do |line|
      match =   PATTERN.match line
      if match
        files << {:name =>match[8] , :last_modified=>Time.parse(match[6]+" "+match[7]+":00 UTC"), :size =>match[5].to_i , :name=>match[8]}
      end
    end
    files
  end


  def move_from_local(source, destination, size = 0)
    command = "-moveFromLocal #{source} #{destination}"
    sys_cmd command, size

  end

  def copy_from_local(source, destination, size = 0)
    command = "-copyFromLocal #{source} #{destination}"
    sys_cmd command, size
  end

  def put(source, destination, size = 0)
    command = "-put #{source} #{destination}"
    sys_cmd command, size
  end

  def copy_to_local(source, destination, size = 0)
    command = "-copyToLocal #{source} #{destination}"
    sys_cmd command, size
  end

  def create_directory(path)
    command =  "-mkdir #{path}"
    sys_cmd command
  end


  def sys_cmd(cmd, size=0, status="")
    #size = size.to_i
    start = Time.now

    cmd = "hadoop fs " + cmd
   result =  %x[#{cmd}]

    time_used = Time.now - start
    out = "#{cmd} - ["
    out << "%04.1fGb " % [size/(1024.0)] if size > 0
    out << "%3.0fs] %s" % [time_used, status]
    out << " %5.1fMb/s" % [(size/time_used)] if size > 0
    puts out
  end
end

#Hdfs.new.list
#Hdfs.new.copy_to_local "/user/hjellum/hdfs_ruby_test.bin", "."
#Hdfs.new.put "hdfs_ruby_test.bin", "/jalla/bnalla/jalla-balla.bin"
#Hdfs.new.copy_from_local "hdfs_ruby_test.bin", "jalla-balla.bin"
#Hdfs.new.move_from_local "jalla-balla.bin", "/user/hjellum/hdfs_ruby_test.bin2"

