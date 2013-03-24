class Controller
	require 'upload.rb'
	include FileUploader
	
	def upload
		@title = "Uploads."
		#@resource = '90dda278959a7d0ee1f115c3360b285b4aa4a238_m.jpeg'
		@resource = 'http://www.urb.com/wp-content/files_flutter/Blood_Brothers_Young_Machetes_V2.jpg'
		FileUploader::Utilities.pull(@resource)
	end
	
end
