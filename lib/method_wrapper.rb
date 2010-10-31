module MethodWrapper
  def self.included(base)
    base.instance_variable_set(:@_wrapped_methods, {})
    base.extend ClassMethods
  end

  module ClassMethods
    def wrap_methods(params)
    end
  end
end

