require 'rake'
require 'rake/testtask'

task :default => :test

desc 'Test the Janus rack middleware.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**_test.rb'
  t.verbose = true
end

