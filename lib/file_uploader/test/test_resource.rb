require 'test/unit'
require_relative '../lib/resource.rb'

require 'debugger'

include FileUploader

class TestLocal < Test::Unit::TestCase
	FILENAME = "c43a8cbe52fecbe6fa25f0b85abb44f6_o.jpg"
	PARAM = "?#{Time.now.to_i}"

	def setup
		resource_file = File.open(File.expand_path("../../test/fixtures/#{FILENAME}", __FILE__))
		resource_url = "http://content.internetvideoarchive.com/content/photos/6894/28955235_.jpg"

		@resource_file = FileUploader::FileResource.new(resource_file)
		@resource_url = FileUploader::HTTPResource.new(resource_url)
	end

	def test_uri_is_string
		assert_equal(@resource_file.uri.class, String, "test uri is a string")
	end

	def test_additional_uri_params
		assert_equal(1, paramify(@resource_file.extension).split(".").length, "uri is properly split on extension and the instance variable knows what this looks like. uri params don't affect split")
	end

	def test_extension
		assert_equal("jpg", @resource_file.extension, "resource knows its extension")
	end

	def test_uri_mimetype_is_expected
		assert_equal(@resource_file.mime_type(paramify(@resource_file.uri)), "image/jpeg")
	end

	def paramify(string)
		string + PARAM
	end
end

