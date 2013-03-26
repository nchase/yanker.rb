module FileUploader
	class FileResource < Resource
		def uri
			self.path
		end

		def basename
			File.basename(@file)
		end
	end
end
