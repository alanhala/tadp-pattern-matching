require 'byebug'
require_relative './pattern_matching'

class Matcher
  def initialize(object, &block)
    @object = object
    @block = block
  end

  def call(object_to_match, context = nil)
    @block.call(@object, object_to_match, context)
  end

  def and(*matchers)
  	Matcher.new(matchers << self) do |matchers, object_to_compare, context|
      matchers.all? { |matcher| matcher.call(object_to_compare) }
    end
  end

  def or(*matchers)
    Matcher.new(matchers << self) do |matchers, object_to_compare, context|
      matchers.any? { |matcher| matcher.call(object_to_compare) }
    end
  end

  def not
    Matcher.new(@object) do |object, object_to_compare, context|
      !@block.call(object, object_to_compare)
    end
  end
end

class Symbol
  def call(value, context)
    context.singleton_class.send(:define_method, self) { value }
    true
  end
end

class Object
  include PatternMatching
end
