require_relative '../lib/resource'


if (!ARGV[0].match(/^http/))
  resource = FileUploader::Resource.create(File.open(ARGV[0]))
else
  resource = FileUploader::Resource.create(ARGV[0])
end

resource.send
