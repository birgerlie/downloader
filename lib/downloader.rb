require_relative "download_task"
require_relative "utils"

class Downloader

  include Utils

  def initialize(params = { })
    @tasks = params[:tasks]||[]
    @sleep_time = params[:sleep_time] || 60

    run_tasks
  end

  def run_tasks
   while (true) do
      @tasks.each do |task|
        begin
        pp "#{task.host} reading remote files"
        remote_files = task.get_remote_files
        pp "#{task.host} read #{remote_files.length} remote files"

        remote_files.each { |f| f[:new_name]=task.create_destination_file_name(f[:name]) }

        pp "#{task.host} reading local files"
        local_files = task.get_local_files
        pp "#{task.host} read #{local_files.length} local files"

        downloads = find_new_or_modified_files(remote_files, local_files)

        pp "#{task.host} have to download #{downloads.length} new files"

        task.download_external_files(downloads)
        rescue e
          pp e
        end

      end

      pp "sleeping for #{@sleep_time} minutes"
      sleep @sleep_time
    end
  end

  def create_file_hash(files = [])
    file_map = { }
    files.each { |f| file_map[f [:name]]= f }
    file_map
  end

  def find_new_or_modified_files(remote_files = [], local_files =[])

    local = create_file_hash local_files
    remote = create_file_hash remote_files

    diff = []

    remote.each do |remote_file_name, file|
      remote_new_file_name =file[:new_name]

      if local.has_key? remote_new_file_name
        #pp "local has file #{remote_new_file_name}"
        unless file_is_untouched(local[remote_new_file_name], file)
          pp "file #{remote_new_file_name } changed"
          diff << file
        else
          #pp "file is equal #{remote_new_file_name }"
        end

      else
        pp "file #{remote_new_file_name} is new "
        diff << file
      end
    end

    diff
  end

  def file_is_untouched(local ={ }, remote={ })
    raise "file is null" if !local or !remote
    #return (local[:size] == remote[:size] and local[:last_modified]>= remote[:last_modified])
    return true #(local[:last_modified] >= remote[:last_modified])
  end


end






