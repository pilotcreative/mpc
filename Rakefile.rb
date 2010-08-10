task :default => [:test]

desc "Test the library"
task :test do
  ruby Dir.glob("test/*")
end