module FileUploader
	class Resource
		require 'mime-types'
		require 'digest/md5'
		require 'fileutils'
		require 'aws/s3'
		require 'yaml'

		attr_accessor :tempfile

		S3_CONFIG = YAML.load_file(File.expand_path('../../../config/s3.yaml', __FILE__))
		S3_KEY    = S3_CONFIG['access_key_id']
		S3_SECRET = S3_CONFIG['secret_access_key']
		S3_BUCKET = S3_CONFIG['bucket']

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

		def destroy
			# destroys local temporary file

			FileUtils.rm(self.tempfile)
		end

		def destroy_s3
			S3Resource.delete(self.basename)
		end

		def send(key, secret, bucket)
			AWS::S3::Base.establish_connection!(
				:access_key_id => key,
				:secret_access_key => secret
			)

			S3Resource.store(
				self.basename,
				File.open(self.path),
				S3_BUCKET,
				:access => :public_read,
				:use_virtual_directories => true
			)
		end

		class S3Resource < AWS::S3::S3Object
			set_current_bucket_to S3_BUCKET
		end
	end
end
