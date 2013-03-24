module FileUploader
	require_relative 'utility.rb'
	include FileUploader::Utility

	def self.make_s3
		require 'rubygems'
		require 'aws/s3'
		require 'yaml'

		s3_config = YAML.load_file(File.expand_path('../../config/s3.yaml', __FILE__))
		AWS::S3::Base.establish_connection!( :access_key_id => s3_config["access_key_id"], :secret_access_key => s3_config["secret_access_key"])
		bucket = s3_config["bucket"]
		path = @resource.is_image ? "/images/" : "/#{@resource.extension}/"
		link_size = @resource.is_image ? "_#{@resource.sizes[0]}" : ''

		@resource.sizes.each do |size|
			path_size = @resource.is_image ? "_#{size}" : ''

			AWS::S3::S3Object.store(
				"#{path + @resource.upload_name + path_size}.#{@resource.extension}",
				File.open("#{RAILS_ROOT}/tmp/#{@resource.upload_name + path_size}.#{@resource.extension}"),
				bucket, :access => :public_read, :use_virtual_directories => true)

			if @resource.is_image
				# 'sig' function lol
				AWS::S3::S3Object.store(
					"#{path + @resource.upload_name}_sig.#{@resource.extension}",
					File.open("#{RAILS_ROOT}/tmp/#{@resource.upload_name}_sig.#{@resource.extension}"),
					bucket, :access => :public_read, :use_virtual_directories => true)
			end
		end
		@resource.link = "http://#{bucket + path + @resource.upload_name + link_size}.#{@resource.extension}"
	end
end
