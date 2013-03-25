module FileUploader
	class Resource
		require 'mime-types'

		attr_reader :uri, :upload_name, :is_image, :is_tempfile, :resource_file, :basename, :extension, :path
		attr_accessor :link, :sizes, :extension

		def initialize(resource)
		end

		def build_metadata
			@upload_name = File.basename(uri).split(".").first

			# should this behavior go somewhere else?
			require 'digest/md5'
			@upload_name = Digest::MD5.hexdigest(@upload_name)
		end

		def extension
			self.uri.chomp.downcase.gsub(/.*\./o, '')
		end

		def image
			mime_type.split("/")[0] ==	"image" ? true: false
		end

		def mime_type(uri)
			clean_uri = uri.split("?").first

			MIME::Types.type_for(clean_uri).first
		end
	end

	class FileResource < Resource
		def initialize(resource)
			@file = resource

			@basename = File.basename(resource)

			build_metadata
		end

		def uri
			@file.path
		end
	end

	class HTTPResource < Resource
		def initialize(resource)
			@file = resource

			build_metadata
		end

		def uri
			@file
		end
	end
end
