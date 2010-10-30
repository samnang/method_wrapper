# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'method_wrapper/version'

Gem::Specification.new do |s|
  s.name        = "method_wrapper"
  s.version     = MethodWrapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Samnang Chhun"]
  s.email       = ["samnang.chhun@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/method_wrapper"
  s.summary     = "How easy to wrap new features around (before and after) existing methods call with method_wrapper."
  s.description = "This gem help you to to wrap new features around (before and after) existing methods call on Any classes. The before_ and after_ callbacks will run as soon as you call wrapped method."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "[none]"

  s.add_development_dependency "bundler", ">= 1.0.0.rc.5"
  s.add_development_dependency "rspec", ">= 2.0.0"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end

