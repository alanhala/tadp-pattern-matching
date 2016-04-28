require 'byebug'
require_relative 'pattern_matching'

class Matcher
  def initialize(object, &block)
    @object = object
    @block = block
  end

  def call(object_to_match)
    @block.call(@object, object_to_match)
  end

  def and(*matchers)
  	Matcher.new(matchers << self) do |matchers, object_to_compare|
      matchers.all? { |matcher| matcher.call(object_to_compare) }
    end
  end

  def or(*matchers)
    Matcher.new(matchers << self) do |matchers, object_to_compare|
      matchers.any? { |matcher| matcher.call(object_to_compare) }
    end
  end

  def not
    Matcher.new(@object) do |object, object_to_compare|
      !@block.call(object, object_to_compare)
    end
  end
end

class Object
  include PatternMatching
end


class Symbol

  def call(value, bind_object)
    bind_object.singleton_class.send(:attr_accessor, self)

    setter = (self.to_s + '=').to_sym
    bind_object.send(setter, value)

    true
  end

end


def with(*matchers, &block)

  binding_object = Object.new

  Proc.new do
  |value|

    if(matchers.all? { |matcher| matcher.call(value, binding_object) })
      binding_object.instance_eval &block
      return
    end
  end

end
