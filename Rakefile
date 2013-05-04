require 'rake/testtask'
require 'rspec/core/rake_task'
require 'bundler'

task :default => :spec

Rake::TestTask.new do |task|
  task.libs << "test"
  task.test_files = FileList['test/test*.rb']
  task.verbose = true
end

RSpec::Core::RakeTask.new(:spec)

task :coverage do
  `rake spec`
  `open coverage/index.html`
end

Bundler::GemHelper.install_tasks
