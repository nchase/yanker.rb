# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_uploader/version'

Gem::Specification.new do |spec|
  spec.name          = "file_uploader"
  spec.version       = FileUploader::VERSION
  spec.authors       = ["Noah Chase"]
  spec.email         = ["nchase@gmail.com"]
  spec.description   = %q{a little file uploader}
  spec.summary       = %q{uploads files}
  spec.homepage      = "http://github.com/nchase/file_uploader"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'mime-types'
  spec.add_dependency 'aws-s3'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
