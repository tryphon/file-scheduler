# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "file_scheduler/version"

Gem::Specification.new do |s|
  s.name        = "file_scheduler"
  s.version     = FileScheduler::VERSION
  s.authors     = ["Alban Peignier"]
  s.email       = ["alban@tryphon.eu"]
  s.homepage    = "http://projects.tryphon.eu/filescheduler"
  s.summary     = %q{Schedule contents from files}
  s.description = %q{Manage a audio/video program from a simple directory}

  s.rubyforge_project = "file_scheduler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
