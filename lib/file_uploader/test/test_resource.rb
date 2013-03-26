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

		@resource_file = FileUploader::Resource.create(resource_file)
		@resource_url = FileUploader::Resource.create(resource_url)
	end

	def test_uri_is_string
		assert_equal(@resource_file.uri.class, String, "test uri is a string")
		assert_equal(@resource_url.uri.class, String, "test uri is a string")
	end

	def test_additional_uri_params
		assert_equal(1, paramify(@resource_file.extension).split(".").length, "uri is properly split on extension")
		assert_equal(1, paramify(@resource_url.extension).split(".").length, "uri is properly split on extension")
	end

	def test_extension
		assert_equal("jpg", @resource_file.extension, "resource knows its extension")
		assert_equal("jpg", @resource_url.extension, "resource knows its extension")
	end

	def test_uri_mimetype_is_expected
		assert_equal(@resource_file.mime_type(paramify(@resource_file.uri)), "image/jpeg")
		assert_equal(@resource_url.mime_type(paramify(@resource_url.uri)), "image/jpeg")
	end

	def test_uuid_is_expected
		# note: this might not actually be globally unique.
		# figure out whether or not this is true and improve
		# if necessary.

		assert_equal("30d70aae38dfe202d62229346644e5d4", @resource_file.pseudo_uuid)
	end

	def paramify(string)
		string + PARAM
	end
end

