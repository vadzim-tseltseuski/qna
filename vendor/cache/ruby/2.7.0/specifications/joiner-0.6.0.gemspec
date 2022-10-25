# -*- encoding: utf-8 -*-
# stub: joiner 0.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "joiner".freeze
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Pat Allan".freeze]
  s.date = "2020-12-12"
  s.description = "Builds ActiveRecord outer joins from association paths and provides references to table aliases.".freeze
  s.email = ["pat@freelancing-gods.com".freeze]
  s.homepage = "https://github.com/pat/joiner".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Builds ActiveRecord joins from association paths".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 6.1.0"])
    s.add_development_dependency(%q<combustion>.freeze, ["~> 1.1"])
    s.add_development_dependency(%q<rails>.freeze, [">= 6.1.0"])
    s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 4"])
    s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 6.1.0"])
    s.add_dependency(%q<combustion>.freeze, ["~> 1.1"])
    s.add_dependency(%q<rails>.freeze, [">= 6.1.0"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 4"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
  end
end
