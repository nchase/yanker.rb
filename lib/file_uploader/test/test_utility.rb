require 'test/unit'
require File.expand_path('../../lib/utility.rb', __FILE__)

include FileUploader::Utility

		#@resource = Resource.new("http://content.internetvideoarchive.com/content/photos/6894/28955235_.jpg")

class TestLocal < Test::Unit::TestCase
	FILENAME = "c43a8cbe52fecbe6fa25f0b85abb44f6_o.jpg"

	def setup
		file = File.open(File.expand_path("../../test/fixtures/#{FILENAME}", __FILE__))
		@resource = Resource.new(file)
	end
	def test_uri
		assert_equal(@resource.uri.class, String)
	end
end

#class TestUpload < Test::Unit::TestCase
#end

#class TestImage < Test::Unit::TestCase
#end
