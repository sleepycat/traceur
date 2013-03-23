# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "traceur/version"

Gem::Specification.new do |s|
  s.name        = "traceur"
  s.version     = Traceur::VERSION
  s.authors     = ["Mike Williamson"]
  s.email       = ["blessedbyvirtuosity@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{ Tracing method calls with SVG }
  s.description = %q{ An experimental library to trace method calls using SVG }

  s.rubyforge_project = "traceur"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec"
end
