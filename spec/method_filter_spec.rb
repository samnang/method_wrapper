require 'spec_helper'

describe MethodFilter do
  describe ".method_filter, stores methods that want to have filters" do
    it "calls after method defined" do
      klass = ClassBuilder.a_class_has_methods_and_calls_after_methods_defined

      verify_methods_filters(klass)
    end

    it "calls before method defined" do
      klass = ClassBuilder.a_class_has_methods_and_calls_before_methods_defined

      verify_methods_filters(klass)
    end

    def verify_methods_filters(klass)
      klass.instance_variable_get(:@_filtered_methods).should ==
        [:method_name, :second_method_name]
    end
  end

  context "invoke the method that has filter" do
    it "should invoke _before_method_name and after_method_name" do
      klass = ClassBuilder.a_class_has_before_and_after_method_filter
      obj = klass.new

      obj.method_name

      obj.instance_variable_get(:@has_called_before_filter).should eql(true)
      obj.instance_variable_get(:@has_called_after_filter).should eql(true)
    end

    it "should ignore filters if user hasn't defined" do
      klass = ClassBuilder.a_class_has_partial_method_filter
      obj = klass.new

      obj.method_name

      obj.instance_variable_get(:@has_called_before_filter).should eql(true)
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
      obj.instance_variable_get(:@has_called_after_filter).should eql(true)
    end
  end
end

