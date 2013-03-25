module FileUploader
	class Resource
		require 'mime-types'
		require 'digest/md5'

		attr_reader :uri, :basename, :extension, :path, :uuid
		attr_accessor :link, :sizes, :extension

		def initialize(resource)
		end

		def create_uuid
			@uuid = Digest::MD5.hexdigest(@file.path)
		end

		def extension
			self.uri.chomp.downcase.gsub(/.*\./o, '')
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
		end

		def uri
			@file.path
		end
	end

	class HTTPResource < Resource
		def initialize(resource)
			@file = resource
		end

		def uri
			@file
		end
	end
end
