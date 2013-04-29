module FileUploader
	class HTTPResource < Resource
		require 'net/http'

		def initialize(resource)
			super

			status, file = Net::HTTP.get_response(URI.parse(self.uri))

			File.open(self.basename, 'wb') do |open_file|
				open_file.print(file)
			end

			self.tempfile = File.open(self.basename)
		end

		def basename
			File.basename(self.uri)
		end

		def path
			File.realdirpath(self.tempfile)
		end
	end
end
