module MethodFilter
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def method_filter(*args)
      @_filtered_methods = args
    end
  end
end

