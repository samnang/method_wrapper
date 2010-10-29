require 'rspec'
require_relative '../lib/method_filter.rb'

describe MethodFilter do
  describe "#method_filter, stores methods that want to has filters" do
    it "should store method name when calls after method defined" do
      klass =
        Class.new do
          include MethodFilter

          def my_method
            puuts 'hi'
          end

          method_filter :my_method
        end

      klass.instance_variable_get(:@_filtered_methods).should == [:my_method]
    end

    it "should store method name when calls before method defined" do
      klass =
        Class.new do
          include MethodFilter
          method_filter :my_method

          def my_method
            puuts 'hi'
          end
        end

      klass.instance_variable_get(:@_filtered_methods).should == [:my_method]
    end
  end
end

