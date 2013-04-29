require_relative 'test_resource'

class TestDataStore < TestResource
	S3_CONFIG = YAML.load_file(File.expand_path('../../config/s3.yaml', __FILE__))
	S3_KEY = S3_CONFIG['access_key_id']
	S3_SECRET = S3_CONFIG['secret_access_key']
	S3_BUCKET = S3_CONFIG['bucket']

	class S3Object < AWS::S3::S3Object
		set_current_bucket_to S3_BUCKET
	end

	def teardown
		@resources.each { |resource|
			resource.destroy
			resource.destroy_s3
		}
	end

	def test_sends_to_datastore
		@resources.each { |resource|
			resource.send(S3_KEY, S3_SECRET, S3_BUCKET)

			assert(S3Object.exists?(resource.basename))
		}
	end
end
