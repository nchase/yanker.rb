module FileUploader
	require_relative 'utility.rb'
	include FileUploader::Utility

	def self.make_temp(*resource)
		require 'rubygems'
		require 'net/http'
		require 'fileutils'
		FileUtils.mkdir_p '/tmp/upload'

		uri = (resource[0].class == Array ? resource[0][0] : resource[0])

		@resource = Resource.new(uri)
		@resource.compute

		@temp_holder = Array.new

		if @resource.is_image
			make_temp_images
		else
			make_temp_other
		end

		return @resource
	end
end
