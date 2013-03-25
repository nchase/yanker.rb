module FileUploader
	module Utility
		class Resource
			require 'mime-types'

			attr_reader :uri, :upload_name, :is_image, :is_http, :is_tempfile, :resource_file, :basename
			attr_accessor :link, :sizes, :extension

			def initialize(resource)
				@uri = resource.path
				@file = resource
				@basename = File.basename(@file)

				build_metadata
			end

			def build_metadata
				@upload_name = File.basename(uri).split(".").first
				@extension = uri.downcase.split(".").last.split("?").first

				@is_http = uri =~ /^http:\/\// ? true : false

				if @is_http
					# assume screwed up url extensions are images. (awful)
					if @extension =~ /\//
						@is_image = true
					end
				end

				require 'digest/md5'
				@upload_name = Digest::MD5.hexdigest(@upload_name)
			end
		end

		def image
			mime_type.split("/")[0] ==	"image" ? true: false
		end

		def mime_type(uri)
			clean_uri = uri.split("?").first

			MIME::Types.type_for(clean_uri).first
		end

		def make_temp_images
			require 'RMagick'
			image_holder = Magick::ImageList.new
			if @resource.is_http
				status, temp_blob = Net::HTTP.get_response(URI.parse(@resource.uri))
			else
				temp_blob = File.open(File.expand_path(@resource.uri)).read
			end

			@resource.sizes = ['o', 600, 400, 100, 15]

			image_holder.from_blob(temp_blob)
			#strip out profiles and comments, unless the image is a gif, because apparently that breaks gifs.
			unless @resource.extension == 'gif'
				image_holder = image_holder.strip!
			end

			if @resource.is_http
				# handle image files that don't have proper extension
				if @resource.extension =~ /\//
					@resource.extension = image_holder.format
				end
			end

			image_holder.write("#{RAILS_ROOT}/tmp/#{@resource.upload_name}_#{@resource.sizes[0]}.#{@resource.extension}")
			@temp_holder << "#{RAILS_ROOT}/tmp/#{@resource.upload_name}_#{@resource.sizes[0]}.#{@resource.extension}"

			@resource.sizes.drop(1).each do |size|
				size = size.to_i
				image_holder.resize_to_fill(size, size).strip!.write("#{RAILS_ROOT}/tmp/#{@resource.upload_name}_#{size}.#{@resource.extension}")
				@temp_holder << "#{RAILS_ROOT}/tmp/#{@resource.upload_name}_#{size}.#{@resource.extension}"
			end
			# 'sig' function lol
			image_holder.resize(502,145).write("#{RAILS_ROOT}/tmp/#{@resource.upload_name}_sig.#{@resource.extension}")
		end

		def make_temp_other
			@resource.sizes = ['o']
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
end
