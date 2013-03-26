module FileUploader
	require_relative 'utility.rb'
	include FileUploader::Utility

	def self.make_s3
		require 'rubygems'
		require 'aws/s3'
		require 'yaml'

		s3_config = YAML.load_file(File.expand_path('../../config/s3.yaml', __FILE__))

		AWS::S3::Base.establish_connection!(
			:access_key_id => s3_config["access_key_id"],
			:secret_access_key => s3_config["secret_access_key"]
		)

		bucket = s3_config["bucket"]

		path = "/#{@resource.extension}/"

		AWS::S3::S3Object.store(
			# path,
			# File - should open IO stream (e.g. `File.open('path/to/file')`)
			bucket,
			:access => :public_read,
			:use_virtual_directories => true
		)

		@resource.link = "http://#{bucket + path + @resource.upload_name}.#{@resource.extension}"
	end
end
