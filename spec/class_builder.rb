class ClassBuilder
  class << self
    def a_class_has_methods_and_calls_after_methods_defined
      Class.new do
        include MethodWrapper

        def method_name
        end

        def second_method_name
        end

        wrap_methods :method_name, :second_method_name
      end
    end

    def a_class_has_methods_and_calls_before_methods_defined
      Class.new do
        include MethodWrapper
        wrap_methods :method_name, :second_method_name

        def method_name
        end

        def second_method_name
        end
      end
    end

    def a_class_has_before_and_after_wrap_methods
      Class.new do
        include MethodWrapper
        wrap_methods :method_name

        def method_name
        end

        private
        def before_method_name
          @has_called_before_callback = true
        end

        def after_method_name
          @has_called_after_callback = true
        end
      end
    end

    def a_class_has_partial_callback
      Class.new do
        include MethodWrapper

        def method_name
        end

        private
        def before_method_name
          @has_called_before_callback = true
        end

        wrap_methods :method_name
      end
    end

    def a_class_has_method_with_args_and_block
      Class.new do
        include MethodWrapper
        wrap_methods :method_name

        def method_name(param)
          @param = param
          yield
        end

        private
        def after_method_name
          @has_called_after_callback = true
        end
      end
    end
  end
end

