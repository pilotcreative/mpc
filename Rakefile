require "bundler"
require "rake/testtask"
Bundler::GemHelper.install_tasks

task :default => :test

desc "Test the library"
Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end