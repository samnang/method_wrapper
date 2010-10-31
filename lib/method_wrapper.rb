module MethodWrapper
  def self.included(base)
    base.instance_variable_set(:@_wrapped_methods, {})
    base.extend ClassMethods
  end

  module ClassMethods
    def wrap_methods(params)
      method_name, feature = params.first
      if method_name.instance_of? Array
        method_name.each do |name|
          @_wrapped_methods[name] = feature
          _wrap_method!(name, feature)
        end
      else
        @_wrapped_methods.merge!(params)
        _wrap_method!(method_name, feature)
      end
    end

    private
    def _wrap_method!(name, feature)
      name = name.to_s
      feature_method_name = name.end_with?("!", "?", "=") ?
                              "#{name[0..-2]}_with_#{feature}#{name[-1]}" :
                              "#{name}_with_#{feature}"

      alias_method "origin_#{name}", feature_method_name
      alias_method name, feature_method_name
    end
  end
end

