require 'test/unit'
require 'debugger'

require_relative '../lib/resource.rb'

class TestLocal < Test::Unit::TestCase
	FILENAME = "c43a8cbe52fecbe6fa25f0b85abb44f6_o.jpg"
	PARAM = "?#{Time.now.to_i}&whyisthisurlsoLong=true&thisistotallyaRealURI.bleh"

	def setup
		resource_file = File.open(File.expand_path("../../test/fixtures/#{FILENAME}", __FILE__))
		resource_url = "http://content.internetvideoarchive.com/content/photos/6894/28955235_.jpg"

		@resource_file = FileUploader::Resource.create(resource_file)
		@resource_url = FileUploader::Resource.create(resource_url)
		@resources = [@resource_file, @resource_url]
	end

	def test_uri_is_string
		@resources.each { |resource|
			assert_equal(resource.uri.class, String, "test uri is a string")
		}
	end

	def test_additional_uri_params
		@resources.each { |resource|
			assert_equal(nil, paramify(resource.extension).split("?").first.match(/(\?|\.|&)/), "uri is properly split on extension")
		}
	end

	def test_extension
		@resources.each { |resource|
			assert_equal("jpg", resource.extension, "resource knows its extension")
		}
	end

	def test_uri_mimetype_is_expected
		@resources.each { |resource|
			assert_equal(resource.mime_type(paramify(@resource_file.uri)), "image/jpeg")
		}
	end

	def test_uuid_is_expected
		# note: this might not actually be globally unique.
		# figure out whether or not this is true and improve
		# if necessary.

		assert_equal("30d70aae38dfe202d62229346644e5d4", @resource_file.pseudo_uuid)
		# we need another test here for http resources.
	end

	def test_file_basename_is_correct
		assert_equal(FILENAME, @resource_file.basename)
	end

	def paramify(string)
		string + PARAM
	end
end

