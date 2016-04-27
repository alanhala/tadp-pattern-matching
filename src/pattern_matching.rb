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
        result = (list == list_to_compare)
      elsif list.size <= list_to_compare.size
        result = list.zip(list_to_compare).select{ |x, y| !y.nil? }.all? { |x, y| x == y }
      else
        result = false
      end
    end
  end

  def duck(*methods)
    Matcher.new(methods) do |methods, object|
      methods.all? { |method| object.methods.include? method }
    end
  end
end
