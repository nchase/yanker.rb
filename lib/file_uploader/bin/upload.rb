require_relative '../lib/make_temp'
require_relative '../lib/make_s3'
include FileUploader

FileUploader.make_temp
FileUploader.make_s3
