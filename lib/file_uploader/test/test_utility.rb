require 'test/unit'
require File.expand_path('../../lib/utility.rb', __FILE__)

include FileUploader::Utility

		#@resource = Resource.new("http://content.internetvideoarchive.com/content/photos/6894/28955235_.jpg")

class TestLocal < Test::Unit::TestCase
	def setup
		file = File.open(File.expand_path('../../test/fixtures/test.jpeg', __FILE__))
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
