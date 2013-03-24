# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "action_cost/version"

Gem::Specification.new do |s|
  s.name        = "action_cost"
  s.version     = ActionCost::VERSION
  s.date        = "2013-03-20"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Philippe Le Rohellec"]
  s.email       = ["philippe@lerohellec.com"]
  s.homepage    = "https://github.com/plerohellec/action_cost"
  s.summary     = %q{ActionCost is a Rails 3 engine implemented as a gem. It hooks into ActiveRecord (and RecordCache if used) and counts the number of SQL queries per controller action and per table.}
  s.description = ""

  s.add_development_dependency "shoulda"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "bundler"

  s.add_development_dependency "jeweler"
  s.add_development_dependency "rcov"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
