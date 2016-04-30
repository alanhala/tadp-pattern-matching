require 'byebug'
require_relative 'pattern_matching'

class Matcher
  def initialize(object, &block)
    @object = object
    @block = block
  end

  def call(object_to_match, binding_object = Object.new)
    @block.call(@object, object_to_match, binding_object)
  end

  def and(*matchers)
  	Matcher.new(matchers << self) do |matchers, object_to_compare, binding_object|
      matchers.all? { |matcher| matcher.call(object_to_compare, binding_object) }
    end
  end

  def or(*matchers)
    Matcher.new(matchers << self) do |matchers, object_to_compare, binding_object|
      matchers.any? { |matcher| matcher.call(object_to_compare, binding_object) }
    end
  end

  def not
    Matcher.new(@object) do |object, object_to_compare, binding_object|
      !@block.call(object, object_to_compare, binding_object)
    end
  end
end

class Object
  include PatternMatching
end



############## ACA VOY PONIENDO LOS INTENTOS DE BINDING Y MATCHES #######

class Symbol
  def call(value, bind_object = Object.new)
    bind_object.singleton_class.send(:attr_accessor, self)

    setter = (self.to_s + '=').to_sym
    bind_object.send(setter, value)

    true
  end
end


def otherwise(&block)
  raise MatchFoundException.new(block.call)
end

def with(*matchers, &block)
  binding_object = Object.new

  if matchers.all? { |matcher| matcher.call(object_to_match, binding_object) }
    raise MatchFoundException.new(binding_object.instance_eval &block)
  end
end


def matches?(object_to_match, &block)
  ejecutador = Object.new
  :object_to_match.call(object_to_match, ejecutador)

  begin
    ejecutador.instance_eval &block
  rescue MatchFoundException => e
    e.data
  end
end

class MatchFoundException < StandardError
  attr_accessor :data

  def initialize(data)
    self.data = data
  end
end