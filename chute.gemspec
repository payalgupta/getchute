# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chute/version"
require "httparty"

Gem::Specification.new do |s|
  s.name        = "chute"
  s.version     = Chute::VERSION
  s.authors     = ["Payal Gupta"]
  s.email       = ["payal@getchute.com"]
  s.homepage    = ""
  s.summary     = %q{Chute API Integration}
  s.description = %q{This gem allows to map your models with a chute.}

  s.rubyforge_project = "chute"

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.test_files    = Dir.glob("test/**/*.rb")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
