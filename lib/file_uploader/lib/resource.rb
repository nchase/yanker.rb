module FileUploader
	class Resource
		require 'mime-types'
		require 'digest/md5'

		def self.create(resource)
			if resource.class == File
				return FileUploader::FileResource.new(resource)
			end

			FileUploader::HTTPResource.new(resource)
		end

		def initialize(resource)
			@file = resource
		end

		def pseudo_uuid
			Digest::MD5.hexdigest(self.path)
		end

		def extension
			self.uri.chomp.downcase.gsub(/.*\./o, '')
		end

		def path
			@file.path
		end

		def uri
			@file
		end

		def mime_type(uri)
			clean_uri = uri.split("?").first

			MIME::Types.type_for(clean_uri).first
		end
	end

	class FileResource < Resource
		def uri
			self.path
		end
	end

	class HTTPResource < Resource
	end
end
