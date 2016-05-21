require_relative './match_found_exception'

module PatternMatching
  def val(value)
    Matcher.new(value) do |val, val_to_compare, context|
      val == val_to_compare
    end
  end

  def type(klass_type)
    Matcher.new(klass_type) do |klass, klass_to_compare, context|
      klass_to_compare.is_a? klass
    end
  end

  def list(list, match_size = true)
    Matcher.new(list) do |list, list_to_compare, context|
      if match_size
        list.size == list_to_compare.size && same_elements(list, list_to_compare, context)
      else
        list.size <= list_to_compare.size && list_included?(list, list_to_compare, context)
      end
    end
  end

  def duck(*methods)
    Matcher.new(methods) do |methods, object, context|
      methods.all? { |method| object.methods.include? method }
    end
  end

  def with(*matchers, &block)
    context = Object.new
    if !matchers.empty? && matchers.all? { |matcher| matcher.call(self, context) }
      raise MatchFoundException.new(context.instance_eval(&block))
    end
  end

  def otherwise(&block)
    yield
  end

  def matches?(an_object, &block)
    begin
      an_object.instance_eval(&block)
    rescue MatchFoundException => e
      e.data
    end
  end

  private

  def same_elements(list, list_to_compare, context)
    list.zip(list_to_compare).all? { |x, y| check_match(x, y, context) }
  end

  def check_match(x, y, context)
    x.respond_to?(:call) ? x.call(y, context) : val(x).call(y)
  end

  def list_included?(list, list_to_compare, context)
    list.zip(list_to_compare).select{ |x, y| !y.nil? }.all? { |x, y| check_match(x, y, context) }
  end
end
