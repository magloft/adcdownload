lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adcdownload/version'

Gem::Specification.new do |s|
  s.name        = "adcdownload"
  s.version     = ADCDownload::VERSION
  s.licenses    = ["BSD-3-Clause"]
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Strebitzer"]
  s.email       = ["tobias.strebitzer@magloft.com"]
  s.homepage    = "https://github.com/MagLoft/adcdownload"
  s.summary     = "ADCDownload - Apple Developer Center Downloader."
  s.description = "This gem helps you download files from Apple Developer Center."
  s.required_rubygems_version = '>= 2.4.7'
  s.add_runtime_dependency "bundler", "~> 1.10"
  s.add_runtime_dependency "activesupport", "~> 4.2"
  s.add_runtime_dependency "logging", "~> 2.0"
  s.add_runtime_dependency "commander", "~> 4.3"
  s.add_runtime_dependency "spaceship", "~> 0.7"
  s.add_runtime_dependency "http-cookie", "~> 1.0"
  s.add_development_dependency "rspec", "~> 3.3"
  s.add_development_dependency "pry", "~> 0.10"
  s.add_development_dependency "rubocop", "~> 0.32"
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = 'lib'
end
