require_relative "trampoline/version"
require_relative "trampoline/jump"
require_relative "trampoline/bounce"

module Trampoline

  def self.included(base)
    base.include Helpers
    base.extend  Decorator

    if base.name.split("::").last != "Barani"
      base.const_set("Barani", Class.new(base))
      base.const_get("Barani").include(Trampoline)
    end
  end

  def self.extended(base)
    base.extend(Helpers)
    base.extend(Decorator)
  end

  module Helpers
    def jump(method)
      Jump.new(method)
    end

    def bounce(&block)
      Bounce.new &block
    end
  end


  module Decorator
    def trampoline(method_name, **options)
      options[:helper] ||= "#{method_name}_helper".to_sym

      define_method method_name do |*args|
        jump(method(options[:helper])).call(*args)
      end
    end

    def barani(method_name, **options)
      method_helper_name =  "#{method_name}_helper".to_sym

      alias_method method_helper_name, method_name

      self.class_eval do

        define_method method_name do |*args|
          barani_class = self.class.const_get("Barani")
          jump(barani_class.new.method(method_helper_name)).call(*args)
        end
      end

      self.const_get("Barani").class_eval do

        define_method method_name do |*args|
          bounce{ self.__send__(method_helper_name, *args) }
        end
      end
    end
  end
end
