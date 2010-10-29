module MethodFilter
  def self.included(base)
    base.instance_variable_set(:@_filtered_methods, [])
    base.extend ClassMethods
  end

  module ClassMethods
    def method_added(name)
      return if @disable_hook_method_added

      wrap_method(name) if @_filtered_methods.include? name
    end

    def method_filter(*args)
      @_filtered_methods = args

      wrap_method(@_filtered_methods[0]) if instance_method_defined? @_filtered_methods[0]
    end

    private
    def wrap_method(name)
      @disable_hook_method_added = true

      origin_method_name = "origin_#{name}"
      origin_method = instance_method(name)

      alias_method origin_method_name, name

      define_method(name) do
        send("_before_#{name}")
        origin_method.bind(self).call
        send("_after_#{name}")
      end

      @disable_hook_method_added = false
    end

    def instance_method_defined?(name)
      instance_methods.include? name.to_sym
    end
  end
end

