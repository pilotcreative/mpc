Gem::Specification.new do |s|
  s.name = "mpc"
  s.version = "0.5"
  s.date = "2010-08-11"
  s.summary = "MPD client gem"
  s.email = "michal.krzyzanowski+mpc@gmail.com"
  s.description = "Ruby MPD client gem"
  s.authors = ['Michał Krzyżanowski']
  s.require_path = "lib"
  s.add_dependency("rubytree")
  s.files = Dir.glob("lib/**/*")
  s.test_files = Dir.glob("test/**/*")
end