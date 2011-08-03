# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mpc/version"

Gem::Specification.new do |s|
  s.name        = "mpc"
  s.version     = Mpc::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michał Krzyżanowski"]
  s.email       = ["michal.krzyzanowski+github@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{MPD client}
  s.description = %q{Ruby MPD client}

  s.rubyforge_project = "mpc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
