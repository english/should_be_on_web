# -*- encoding: utf-8 -*-
require File.expand_path('../lib/should_be_on_web/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jamie English"]
  gem.email         = ["jamienglish@gmail.com"]
  gem.description   = %q{Tells me which products are web candidates.}
  gem.summary       = %q{See cucumber features.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "should_be_on_web"
  gem.require_paths = ["lib"]
  gem.version       = ShouldBeOnWeb::VERSION

  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake','~> 0.9.2')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('guard-cucumber')
  gem.add_development_dependency('guard-bundler')
  gem.add_development_dependency('growl') if RbConfig::CONFIG['host_os'] =~ /darwin/
  gem.add_development_dependency('libnotify') if RbConfig::CONFIG['host_os'] =~ /linux/

  gem.add_dependency('methadone', '~> 1.1.0')
  gem.add_dependency('nokogiri', '~> 1.5.2')
  gem.add_dependency('bundler', '~> 1.1.3')
end
