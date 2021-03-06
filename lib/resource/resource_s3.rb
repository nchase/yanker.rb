require 'aws/s3'
require 'yaml'

module S3Resource
  if (defined?(Rails))
    S3_CONFIG = YAML.load_file("#{Rails.root}/config/yanker.yaml")
  else
    S3_CONFIG = YAML.load_file(File.expand_path('../../../config/s3.yaml', __FILE__))
  end

  S3_KEY    = S3_CONFIG['access_key_id']
  S3_SECRET = S3_CONFIG['secret_access_key']
  S3_BUCKET = S3_CONFIG['bucket']

  class S3Object < AWS::S3::S3Object
    set_current_bucket_to S3_BUCKET
  end

  def destroy_s3
    S3Object.delete(self.basename)
  end

  def send(arguments = {})
    key = arguments[:key] || S3_KEY
    secret = arguments[:secret] || S3_SECRET
    bucket = arguments[:bucket] || S3_BUCKET
    filename = arguments[:filename] || self.basename

    AWS::S3::Base.establish_connection!(
      :access_key_id => key,
      :secret_access_key => secret
    )

    S3Object.store(
      filename,
      File.open(self.path),
      S3_BUCKET,
      :access => :public_read,
      :use_virtual_directories => true
    )

    return "#{S3_BUCKET + '/' + self.basename}"
  end
end
