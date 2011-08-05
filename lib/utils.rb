module Utils
    def get_files_with_info_from_hdfs(hadoop_src)
    printf "finding files and job.info on hdfs:"
    list_files_cmd = "hadoop fs -du #{hadoop_src}"
    directory_list = %x[#{list_files_cmd}]
    total_size = 0
    total_num_docs = 0
    list = []
    directory_list.split("\n").each do |size_filename|
      size, filename = size_filename.split(/\s+/)
      size = size.to_i / (1024*1024)
      job_info = %x[hadoop fs -cat #{filename.strip}/.job.info]
      print "."
      list << [filename, size, job_info]
      total_size += size
      total_num_docs += /\d+\s*documents/.match(job_info).to_s.to_i
    end
    puts " Total size:%6.2fGb DocCount:%9d" % [total_size/(1024.0), total_num_docs]
    return list.sort_by { |name, size, job_info| job_info }
  end

  def sys_cmd(cmd, size=0, status="")
    #size = size.to_i
    start = Time.now
    %x[#{cmd}]
    #sleep(0.1)
    time_used = Time.now - start
    out = "#{cmd} - ["
    out << "%04.1fGb " % [size/(1024.0)] if size > 0
    out << "%3.0fs] %s" % [time_used, status]
    out << " %5.1fMb/s" % [(size/time_used)] if size > 0
    puts out
  end
end

