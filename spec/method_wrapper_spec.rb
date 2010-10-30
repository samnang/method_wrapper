require 'spec_helper'

describe MethodWrapper do
  describe ".wrap_methods, stores methods that want to wrap" do
    it "calls after method defined" do
      klass = ClassBuilder.a_class_has_methods_and_calls_after_methods_defined

      verify_wrapped_methods(klass)
    end

    it "calls before method defined" do
      klass = ClassBuilder.a_class_has_methods_and_calls_before_methods_defined

      verify_wrapped_methods(klass)
    end

    def verify_wrapped_methods(klass)
      klass.instance_variable_get(:@_wrapped_methods).should ==
        [:method_name, :second_method_name]
    end
  end

  context "invoke the wrapped methods" do
    it "should invoke _before_method_name and after_method_name" do
      klass = ClassBuilder.a_class_has_before_and_after_wrap_methods
      obj = klass.new

      obj.method_name

      obj.instance_variable_get(:@has_called_before_callback).should eql(true)
      obj.instance_variable_get(:@has_called_after_callback).should eql(true)
    end

    it "should ignore callbacks if user hasn't defined" do
      klass = ClassBuilder.a_class_has_partial_callback
      obj = klass.new

      obj.method_name

      obj.instance_variable_get(:@has_called_before_callback).should eql(true)
    end

    it "should be able to invoke the method with args and block" do
      klass = ClassBuilder.a_class_has_method_with_args_and_block
      obj = klass.new
      has_called = false

      obj.method_name("value") do
        has_called = true
      end

      obj.instance_variable_get(:@param).should eql("value")
      has_called.should eql(true)
      obj.instance_variable_get(:@has_called_after_callback).should eql(true)
    end
  end
end

