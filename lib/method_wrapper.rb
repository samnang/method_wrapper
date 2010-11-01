module MethodWrapper
  def self.included(base)
    base.instance_variable_set(:@__wrapped_methods, {})
    base.extend ClassMethods
  end

  module ClassMethods
    def wrap_methods(params)
      method_names, feature = params.first
      method_names = [method_names] unless method_names.instance_of? Array

      method_names.each do |name|
        feature_name = feature_method_name(name, feature)
        @__wrapped_methods[name] = feature_name

        __wrap_method!(name, feature_name)
      end
    end

    def method_added(name)
      return if @disable_method_added_hook

      new_added_method_has_in_wrpped_methods(name)
    end

    def include(*modules)
      super

      @__wrapped_methods.each do |k, v|
        __wrap_method!(k, v)
      end
    end

    private
    def __wrap_method!(name, feature_name)
      return unless methods_have_already_defined?(name, feature_name)

      origin_name = origin_method_name(name)

      @disable_method_added_hook = true

      alias_method origin_name, name
      alias_method name, feature_name

      @disable_method_added_hook = false

      [:public, :protected, :private].each do |v|
        send(v, name) if send("#{v}_method_defined?", origin_name)
      end
    end

    def feature_method_name(name, feature)
      name = name.to_s
      feature_name = name.end_with?("!", "?", "=") ?
                              "#{name[0..-2]}_with_#{feature}#{name[-1]}" :
                              "#{name}_with_#{feature}"

      feature_name.to_sym
    end

    def origin_method_name(name)
      "origin_#{name}"
    end


    def methods_have_already_defined?(*args)
      args.each {|name| return false unless all_instance_methods.include? name }

      true
    end

    def all_instance_methods
      public_instance_methods +
      protected_instance_methods +
      private_instance_methods
    end

    def new_added_method_has_in_wrpped_methods(name)
      if @__wrapped_methods.has_key? name
        feature_name = @__wrapped_methods[name]
        __wrap_method!(name, feature_name)
      elsif @__wrapped_methods.has_value? name
        name, feature_name = @__wrapped_methods.select{|k, v| v == name }.first
        __wrap_method!(name, feature_name)
      end
    end
  end
end

