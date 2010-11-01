module MethodWrapper
  def self.included(base)
    base.instance_variable_set(:@_wrapped_methods, {})
    base.extend ClassMethods
  end

  module ClassMethods
    def wrap_methods(params)
      method_names, feature = params.first
      method_names = [method_names] unless method_names.instance_of? Array

      method_names.each do |name|
        _wrap_method!(name, feature)
      end
    end

    private
    def _wrap_method!(name, feature)
      name, origin_name, feature_name = generate_method_names(name, feature)
      @_wrapped_methods[name] = feature_name

      alias_method origin_name, name
      alias_method name, feature_name

      [:public, :protected, :private].each do |v|
        send(v, name) if send("#{v}_method_defined?", origin_name)
      end
    end

    def generate_method_names(name, feature)
      name = name.to_s
      origin_name = "origin_#{name}"
      feature_name = name.end_with?("!", "?", "=") ?
                              "#{name[0..-2]}_with_#{feature}#{name[-1]}" :
                              "#{name}_with_#{feature}"

      [name, origin_name, feature_name]
    end
  end
end

