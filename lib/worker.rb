require "date"
class Worker

  def initialize(params = {})
     @params = params

  end

  def list_new_files(since, &block)
    files = []
      list.each do |file|
         if(file[:last_modified] > since)
           if block_given?
             yield file
           end
              files << file
         end
      end
    files
  end



end