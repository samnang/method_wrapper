require 'rspec'

require_relative 'class_builder'
require_relative '../lib/method_wrapper.rb'

RSpec::Matchers.define :has_alias_method do |first, second|
  match do |klass|
    klass.instance_method(first).should == klass.instance_method(second)
  end
end

