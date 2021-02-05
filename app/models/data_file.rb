class DataFile < ActiveRecord::Base
   def self.save(upload,current_user)
      @current_user = current_user
      name = upload['datafile'].original_filename
      directory = "file_uploads"
      # create the file path
      path = File.join(directory, name)
      # write the file
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
      File.open("file_uploads/#{@current_user.first_name}-DK.csv", "w")
      File.open("file_uploads/#{@current_user.first_name}-PICKS.csv", "w")
      File.open("file_uploads/PICKS.csv", "w")
      Dir.foreach("file_uploads/") do|files|
        if files.include?('PICKS')
          IO.readlines("file_uploads/#{files}").each do|picks|
            File.open("file_uploads/PICKS.csv", "a"){|f| f.write(picks)}
          end
        end
      end
      File.open("file_uploads/UNIQS.csv", "w")
      File.readlines("file_uploads/excel.txt").each do|picks|
        if !File.readlines("file_uploads/PICKS.csv").include?(picks)
          File.open("file_uploads/UNIQS.csv", "a"){|f| f.write(picks)}
        end
      end
      @e = IO.readlines("file_uploads/UNIQS.csv")
      @file = IO.readlines(path)
      if @e[0].gsub("\n","").split("\t") == @file[0].gsub(/\n|\r/,"").split(',')[@file[0].gsub(/\n|\r/,"").split(',').count - @e[0].gsub("\n","").split("\t").count..@file[0].gsub(/\n|\r/,"").split(',').count - 1]
      IO.readlines(path).each_with_index do|file,idx|
        if idx == 0
          File.open("file_uploads/#{@current_user.first_name}-DK.csv", "a"){|f| f.write(file)}
        else
          @file = file.gsub(/\n|\r/,"").split(',')
          @excel = idx >= @e.count ? Array.new(@e[0].gsub("\n","").split("\t").count,"") : @e[idx].gsub("\n","").split("\t")
          @merge = @file[0..@file.count - (@excel.count + 1)].concat @excel
          File.open("file_uploads/#{@current_user.first_name}-DK.csv", "a"){|f| f.write("#{@merge.join(',')}\n")}
          File.open("file_uploads/#{@current_user.first_name}-PICKS.csv", "a"){|f| f.write("#{@e[idx]}")}
        end
      end
      else
       File.open("file_uploads/#{@current_user.first_name}-DK.csv", "a"){|f| f.write("
         WRONG FORMAT
         Please Upload Correct Format File
         Headers: #{@e[0].gsub("\n","").split("\t").join(',').to_s}
       ")}
      end
      File.delete(path)
      File.delete("file_uploads/PICKS.csv")
      File.delete("file_uploads/UNIQS.csv")
   end
end