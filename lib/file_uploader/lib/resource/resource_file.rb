module FileUploader
	class FileResource < Resource
		def uri
			self.path
		end

		def basename
			File.basename(@file)
		end

		def initialize(resource)
			super

			FileUtils.copy(self.uri, self.basename)

			self.tempfile = File.open(self.basename)
		end
	end
end
