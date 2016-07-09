# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'super_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "super_crawler"
  spec.version       = SuperCrawler::VERSION
  spec.authors       = ["Hassen Taidirt"]
  spec.email         = ["htaidirt@gmail.com"]

  spec.summary       = %q{Easy (yet efficient) ruby gem to crawl your favorite website.}
  spec.description   = %q{SuperCrawler allows you to easily crawl full web sites or web pages (extracting internal links and assets) in few seconds.}
  spec.homepage      = "https://github.com/htaidirt/super_crawler"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1"
  spec.add_dependency "open_uri_redirections", "~> 0.2"
  spec.add_dependency "thread", "~> 0.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
