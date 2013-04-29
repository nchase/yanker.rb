module FileUploader
	class FileResource < Resource
		def initialize(resource)
			super

			FileUtils.copy(self.uri, self.basename)

			self.tempfile = File.open(self.basename)
		end

		def uri
			self.path
		end

		def basename
			File.basename(@file)
		end
	end
end
