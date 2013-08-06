# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "hairtrigger"
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jon Jensen"]
  s.date = "2013-04-17"
  s.description = "allows you to declare database triggers in ruby in your models, and then generate appropriate migrations as they change"
  s.email = "jenseng@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://github.com/jenseng/hair_trigger"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "1.8.25"
  s.summary = "easy database triggers for active record"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3"])
      s.add_runtime_dependency(%q<ruby_parser>, ["~> 3.0"])
      s.add_runtime_dependency(%q<ruby2ruby>, ["~> 2.0.4"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.12.0"])
      s.add_development_dependency(%q<mysql>, ["~> 2.8.1"])
      s.add_development_dependency(%q<mysql2>, [">= 0.2.7"])
      s.add_development_dependency(%q<pg>, [">= 0.10.1"])
      s.add_development_dependency(%q<sqlite3>, [">= 1.3.6"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.3"])
      s.add_dependency(%q<ruby_parser>, ["~> 3.0"])
      s.add_dependency(%q<ruby2ruby>, ["~> 2.0.4"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.12.0"])
      s.add_dependency(%q<mysql>, ["~> 2.8.1"])
      s.add_dependency(%q<mysql2>, [">= 0.2.7"])
      s.add_dependency(%q<pg>, [">= 0.10.1"])
      s.add_dependency(%q<sqlite3>, [">= 1.3.6"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.3"])
    s.add_dependency(%q<ruby_parser>, ["~> 3.0"])
    s.add_dependency(%q<ruby2ruby>, ["~> 2.0.4"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.12.0"])
    s.add_dependency(%q<mysql>, ["~> 2.8.1"])
    s.add_dependency(%q<mysql2>, [">= 0.2.7"])
    s.add_dependency(%q<pg>, [">= 0.10.1"])
    s.add_dependency(%q<sqlite3>, [">= 1.3.6"])
  end
end
