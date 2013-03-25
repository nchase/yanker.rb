module FileUploader
	class Resource
		require 'mime-types'
		require 'digest/md5'

		attr_reader :uri, :basename, :extension, :path, :uuid

		def self.create(resource)
			if resource.class == File
				FileUploader::FileResource.new(resource)
			else
				FileUploader::HTTPResource.new(resource)
			end
		end

		def initialize(resource)
			@file = resource
		end

		def create_uuid
			@uuid = Digest::MD5.hexdigest(self.path)
		end

		def extension
			self.uri.chomp.downcase.gsub(/.*\./o, '')
		end

		def path
			@file.path
		end

		def mime_type(uri)
			clean_uri = uri.split("?").first

			MIME::Types.type_for(clean_uri).first
		end
	end

	class FileResource < Resource
		def initialize(resource)
			super
			@basename = File.basename(resource)
		end

		def uri
			self.path
		end
	end

	class HTTPResource < Resource
		def uri
			@file
		end
	end
end
