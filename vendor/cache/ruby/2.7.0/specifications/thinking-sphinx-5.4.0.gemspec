# -*- encoding: utf-8 -*-
# stub: thinking-sphinx 5.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "thinking-sphinx".freeze
  s.version = "5.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Pat Allan".freeze]
  s.date = "2021-12-21"
  s.description = "An intelligent layer for ActiveRecord (via Rails and Sinatra) for the Sphinx full-text search tool.".freeze
  s.email = ["pat@freelancing-gods.com".freeze]
  s.executables = ["console".freeze, "loadsphinx".freeze]
  s.files = ["bin/console".freeze, "bin/loadsphinx".freeze]
  s.homepage = "https://pat.github.io/thinking-sphinx/".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "A smart wrapper over Sphinx for ActiveRecord".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 4.2.0"])
    s.add_runtime_dependency(%q<builder>.freeze, [">= 2.1.2"])
    s.add_runtime_dependency(%q<joiner>.freeze, [">= 0.3.4"])
    s.add_runtime_dependency(%q<middleware>.freeze, [">= 0.1.0"])
    s.add_runtime_dependency(%q<innertube>.freeze, [">= 1.0.2"])
    s.add_runtime_dependency(%q<riddle>.freeze, ["~> 2.3"])
    s.add_development_dependency(%q<appraisal>.freeze, ["~> 1.0.2"])
    s.add_development_dependency(%q<combustion>.freeze, ["~> 1.1"])
    s.add_development_dependency(%q<database_cleaner>.freeze, ["~> 1.6.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7.0"])
    s.add_development_dependency(%q<rspec-retry>.freeze, ["~> 0.5.6"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 4.2.0"])
    s.add_dependency(%q<builder>.freeze, [">= 2.1.2"])
    s.add_dependency(%q<joiner>.freeze, [">= 0.3.4"])
    s.add_dependency(%q<middleware>.freeze, [">= 0.1.0"])
    s.add_dependency(%q<innertube>.freeze, [">= 1.0.2"])
    s.add_dependency(%q<riddle>.freeze, ["~> 2.3"])
    s.add_dependency(%q<appraisal>.freeze, ["~> 1.0.2"])
    s.add_dependency(%q<combustion>.freeze, ["~> 1.1"])
    s.add_dependency(%q<database_cleaner>.freeze, ["~> 1.6.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.7.0"])
    s.add_dependency(%q<rspec-retry>.freeze, ["~> 0.5.6"])
  end
end
