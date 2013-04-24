require_relative 'test_resource'

class TestTempFiles < TestResource
	def test_temp_files_for_local
		assert(File.exist?(@resource_file.basename))
	end

	def test_temp_files_for_http
		assert(File.exist?(@resource_url.basename))
	end
end
