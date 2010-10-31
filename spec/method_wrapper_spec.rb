require 'spec_helper'

describe MethodWrapper do
  describe ".wrap_methods" do

    it "should stores the wrapped methods with feature" do
      klass = ClassBuilder.a_class_with_2_methods_add_feature

      verify_wrapped_methods(klass)
    end

    it "should be able call wrap_methods with array of method" do
      klass = ClassBuilder.a_class_calls_wrap_methods_with_array_of_methods

      verify_wrapped_methods(klass)
    end

    it "should wrap new feature to methods" do
      klass = ClassBuilder.a_class_with_2_methods_add_feature

      klass.instance_method(:name!).should == klass.instance_method(:name_with_feature!)
      klass.instance_method(:name1).should == klass.instance_method(:name1_with_feature)
    end

    it "should create new method for origin method" do
      klass = ClassBuilder.a_class_with_2_methods_add_feature

      klass.new.should respond_to :origin_name!
      klass.new.should respond_to :origin_name1
    end

    def verify_wrapped_methods(klass)
      klass.instance_variable_get(:@_wrapped_methods).should ==
        {:name! => :feature, :name1 => :feature}
    end
  end
end

