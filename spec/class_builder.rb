class ClassBuilder
  class << self
    module Methods
      def name!; end
      def name1; end

      def name_with_feature!; end
      def name1_with_feature; end
    end

    def a_class_with_2_methods_add_feature
      Class.new do
        include MethodWrapper
        include Methods

        wrap_methods :name! => :feature
        wrap_methods :name1 => :feature
      end
    end

    def a_class_calls_wrap_methods_with_array_of_methods
      Class.new do
        include MethodWrapper
        include Methods

        wrap_methods [:name!, :name1] => :feature
      end
    end
  end
end

