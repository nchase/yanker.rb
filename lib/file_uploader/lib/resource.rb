module FileUploader
	class Resource
		require 'mime-types'

		attr_reader :uri, :upload_name, :is_image, :is_http, :is_tempfile, :resource_file, :basename, :extension
		attr_accessor :link, :sizes, :extension

		def initialize(resource)
			@uri = resource.path
			@file = resource
			@basename = File.basename(@file)

			build_metadata
		end

		def build_metadata
			@upload_name = File.basename(uri).split(".").first

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

		def extension
			uri.chomp.downcase.gsub(/.*\./o, '')
		end
		def image
			mime_type.split("/")[0] ==	"image" ? true: false
		end

		def mime_type(uri)
			clean_uri = uri.split("?").first

			MIME::Types.type_for(clean_uri).first
		end
	end
end
