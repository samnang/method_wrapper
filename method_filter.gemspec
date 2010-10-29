# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'method_filter/version'

Gem::Specification.new do |s|
  s.name        = "method_filter"
  s.version     = MethodFilter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Samnang Chhun"]
  s.email       = ["samnang.chhun@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/method_filter"
  s.summary     = "How easy to wrap new features around existing methods call with method_filter."
  s.description = "How easy to wrap new features around existing methods call with before and after filter."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "[none]"

  s.add_development_dependency "bundler", ">= 1.0.0.rc.5"
  s.add_development_dependency "rspec", ">= 2.0.0"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end

