# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jsmin"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Grove"]
  s.date = "2008-11-10"
  s.email = "ryan@wonko.com"
  s.homepage = "http://github.com/rgrove/jsmin/"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = "riposte"
  s.rubygems_version = "1.8.25"
  s.summary = "Ruby implementation of Douglas Crockford's JSMin JavaScript minifier."

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
