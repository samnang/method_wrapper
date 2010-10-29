require 'rspec'
require_relative '../lib/method_filter.rb'

describe MethodFilter do
  describe "#method_filter, stores methods that want to has filters" do
    it "should store method names when calls after method defined" do
      klass =
        Class.new do
          include MethodFilter

          def method_name
          end

          def second_method_name
          end

          method_filter :method_name, :second_method_name
        end

      klass.instance_variable_get(:@_filtered_methods).should == [:method_name, :second_method_name]
    end

    it "should store method names when calls before method defined" do
      klass =
        Class.new do
          include MethodFilter
          method_filter :method_name, :second_method_name

          def method_name
          end

          def second_method_name
          end
        end

      klass.instance_variable_get(:@_filtered_methods).should == [:method_name, :second_method_name]
    end
  end

  context "invoke the method that has filter" do
    it "should invoke _before_method_name and after_method_name" do
      klass =
        Class.new do
          include MethodFilter
          method_filter :method_name

          def method_name
          end

          private
          def before_method_name
            @has_called_before_filter = true
          end

          def after_method_name
            @has_called_after_filter = true
          end
        end

      obj = klass.new
      obj.method_name

      obj.instance_variable_get(:@has_called_before_filter).should eql(true)
      obj.instance_variable_get(:@has_called_after_filter).should eql(true)
    end

    it "should ignore filters if user hasn't defined" do
      klass =
        Class.new do
          include MethodFilter

          def method_name
          end

          private
          def before_method_name
            @has_called_before_filter = true
          end

          method_filter :method_name
        end

      obj = klass.new
      obj.method_name

      obj.instance_variable_get(:@has_called_before_filter).should eql(true)
    end

    it "should be able to invoke the method with args and block" do
      klass =
        Class.new do
          include MethodFilter
          method_filter :method_name

          def method_name(param)
            @param = param
            yield
          end

          private
          def after_method_name
            @has_called_after_filter = true
          end
        end

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

