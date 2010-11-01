module MethodWrapper
  def self.included(base)
    base.instance_variable_set(:@_wrapped_methods, {})
    base.extend ClassMethods
  end

  module ClassMethods
    def method_added(name)
      return if @disable_method_added_hoolk

      if @_wrapped_methods.has_key? name
        name, feature_name = @_wrapped_methods.select{|k, v| k == name }.first
        if instance_method_defined?(feature_name)
          _wrap_method!(name, feature_name)
        end
      elsif @_wrapped_methods.has_value? name
        name, feature_name = @_wrapped_methods.select{|k, v| v == name }.first
        if instance_method_defined?(name)
          _wrap_method!(name, feature_name)
        end
      end
    end

    def wrap_methods(params)
      method_names, feature = params.first
      method_names = [method_names] unless method_names.instance_of? Array

      method_names.each do |name|
        feature_name = feature_method_name(name, feature)
        @_wrapped_methods[name] = feature_name

        if instance_method_defined?(name) and instance_method_defined? feature_name
          _wrap_method!(name, feature_name)
        end
      end
    end

    private
    def _wrap_method!(name, feature_name)
      origin_name = origin_method_name(name)

      @disable_method_added_hoolk = true

      alias_method origin_name, name
      alias_method name, feature_name

      @disable_method_added_hoolk = false

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

    def instance_method_defined?(name)
      all_methods = public_instance_methods +
                    protected_instance_methods +
                    private_instance_methods

      all_methods.include? name
    end
  end
end

