require 'lib/file_uploader/lib/make_temp.rb'
require 'lib/file_uploader/lib/make_s3.rb'

include FileUploader

class StaticController < ApplicationController
	def upload
		if request.post?
			if params[:resource]
				@resource = FileUploader.make_temp(params[:resource])
				FileUploader.make_s3
			else
				puts "no resource, empty string, etc"
			end
		end
	end
end
