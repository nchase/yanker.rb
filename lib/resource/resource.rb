module FileUploader
  class Resource
    include S3Resource

    require 'mime-types'
    require 'digest/md5'
    require 'fileutils'

    attr_accessor :tempfile

    def self.create(resource)
      if resource.class == File
        return FileUploader::FileResource.new(resource)
      end

      FileUploader::HTTPResource.new(resource)
    end

    def initialize(resource)
      @file = resource
    end

    def extension
      self.uri.chomp.downcase.gsub(/.*\./o, '')
    end

    def path
      @file.path
    end

    def uri
      @file
    end

    def mime_type(uri)
      clean_uri = uri.split("?").first

      MIME::Types.type_for(clean_uri).first
    end

    def destroy
      # destroys local temporary file

      FileUtils.rm(self.tempfile)
    end
  end
end
