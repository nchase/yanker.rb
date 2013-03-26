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

		make_temp

		return @resource
	end

	def make_temp
		if @resource.is_http
			status, f = Net::HTTP.get_response(URI.parse(@resource.uri))
			File.open("#{RAILS_ROOT}/tmp/#{@resource.upload_name}.#{@resource.extension}", 'wb') do |open_file|
				open_file.print(f)
			end
		else
			require "ftools"
			File.copy(@resource.uri,"#{RAILS_ROOT}/tmp/#{@resource.upload_name}.#{@resource.extension}")
			@temp_holder << "#{RAILS_ROOT}/tmp/#{@resource.upload_name}.#{@resource.extension}"
		end
	end
end
