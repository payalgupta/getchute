# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "get_chute/version"
require "httparty"

Gem::Specification.new do |s|
  s.name        = "get_chute"
  s.version     = GetChute::VERSION
  s.authors     = ["Payal Gupta"]
  s.email       = ["payal@getchute.com"]
  s.homepage    = ""
  s.summary     = %q{Chute API Integration}
  s.description = %q{This gem allows to map your models with a chute.}

  s.rubyforge_project = "get_chute"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
