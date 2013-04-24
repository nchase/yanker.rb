require 'test/unit'
require 'debugger'

require_relative '../lib/resource.rb'

class TestTempFiles < Test::Unit::TestCase
	FILENAME = "c43a8cbe52fecbe6fa25f0b85abb44f6_o.jpg"
	PARAM = "?#{Time.now.to_i}&whyisthisurlsoLong=true&thisistotallyaRealURI.bleh"

	def setup
		resource_file = File.open(File.expand_path("../../test/fixtures/#{FILENAME}", __FILE__))
		resource_url = "http://content.internetvideoarchive.com/content/photos/6894/28955235_.jpg"

		@resource_file = FileUploader::Resource.create(resource_file)
		@resource_url = FileUploader::Resource.create(resource_url)
		@resources = [@resource_file, @resource_url]
	end

	def teardown
	end

	def test_temp_files_for_local
		assert(File.exist?(@resource_file.basename))
	end

	def test_temp_files_for_http
		assert(File.exist?(@resource_url.basename))
	end
end
