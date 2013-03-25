module FileUploader
	class TrashyStrategies
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
