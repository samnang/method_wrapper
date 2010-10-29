module MethodFilter
  def self.included(base)
    base.instance_variable_set(:@_filtered_methods, [])
    base.extend ClassMethods
  end

  private
  def invoke_method(name)
    send(name) if respond_to? name, true
  end

  module ClassMethods
    def method_added(name)
      return if @_disable_hook_method_added

      _wrap_method!(name) if @_filtered_methods.include? name
    end

    def method_filter(*args)
      @_filtered_methods = args

      @_filtered_methods.each do |name|
        _wrap_method!(name) if instance_method_defined? name
      end
    end

    private
    def _wrap_method!(name)
      @_disable_hook_method_added = true

      origin_method_name = "origin_#{name}"
      origin_method = instance_method(name)

      alias_method origin_method_name, name

      define_method(name) do |*args, &block|
        invoke_method("before_#{name}")
        origin_method.bind(self).call(*args, &block)
        invoke_method("after_#{name}")
      end

      @_disable_hook_method_added = false
    end

    def instance_method_defined?(name)
      instance_methods.include? name.to_sym
    end
  end
end

