require 'spec_helper'

describe MethodWrapper do
  describe ".wrap_methods" do
    let(:klass) { klass = ClassBuilder.a_class_with_2_methods_add_feature }

    it "should stores the wrapped methods with feature" do
      verify_wrapped_methods(klass)
    end

    it "should be able call wrap_methods with array of method" do
      klass = ClassBuilder.a_class_calls_wrap_methods_with_array_of_methods

      verify_wrapped_methods(klass)
    end

    it "should wrap new feature to methods" do
      verify_alias_methods(klass)
    end

    it "should create new method for origin method" do
      klass.new.should be_respond_to :origin_name!
      klass.new.should be_respond_to :origin_name1, true #include private
    end

    it "should restore visibility to origin method" do
      klass.private_instance_methods.should include(:name1)
    end

    it "should be able to calls before methods defined" do
      klass = ClassBuilder.a_class_calls_wrap_methods_before_methods_defined

      verify_alias_methods(klass)
    end

    def verify_wrapped_methods(klass)
      klass.instance_variable_get(:@__wrapped_methods).should ==
        {:name! => :name_with_feature!, :name1 => :name1_with_feature}
    end

    def verify_alias_methods(klass)
      klass.should has_alias_method(:name!, :name_with_feature!)
      klass.should has_alias_method(:name1, :name1_with_feature)
    end
  end
end

