class UploadController < ApplicationController
   def index
      render :file => 'app/views/upload/uploadfile.html.erb'
   end
   def uploadFile
      post = DataFile.save( params[:upload],current_user)
   end
   def export
     @csv = IO.readlines("file_uploads/#{current_user.first_name}-DK.csv")
     send_data(@csv.join(""), :filename => "#{current_user.first_name}-DK.csv", :type => "text/csv", :disposition => "attachment")
     File.delete("file_uploads/#{current_user.first_name}-DK.csv")
   end
end