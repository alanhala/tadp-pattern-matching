require_relative './match_found_exception'

module PatternMatching
  def val(value)
    Matcher.new(value) do |val, val_to_compare|
      val == val_to_compare
    end
  end

  def type(klass_type)
    Matcher.new(klass_type) do |klass, klass_to_compare|
      klass_to_compare.is_a? klass
    end
  end

  def list(list, match_size = true)
    Matcher.new(list) do |list, list_to_compare|
      if match_size
        list.size == list_to_compare.size && same_elements(list, list_to_compare)
      else
        list.size <= list_to_compare.size && list_included?(list, list_to_compare)
      end
    end
  end

  def duck(*methods)
    Matcher.new(methods) do |methods, object|
      methods.all? { |method| object.methods.include? method }
    end
  end

  def with(*matchers, &block)
    if !matchers.empty? && matchers.all? { |matcher| matcher.call(self) }
      raise MatchFoundException.new(yield)
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

  def same_elements(list, list_to_compare)
    list.zip(list_to_compare).all? { |x, y| check_match(x, y) }
  end

  def check_match(x, y)
    x.respond_to?(:call) ? x.call(y) : val(x).call(y)
  end

  def list_included?(list, list_to_compare)
    list.zip(list_to_compare).select{ |x, y| !y.nil? }.all? { |x, y| check_match(x, y) }
  end
end
