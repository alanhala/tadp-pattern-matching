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

    Matcher.new(list) do |list, list_to_compare, binding_object|
      if !list_to_compare.is_a? Array
        return false
      end

      if match_size
        list.size == list_to_compare.size && match_lists?(list, list_to_compare, binding_object)
      else
        list.size <= list_to_compare && match_lists?(list, list_to_compare, binding_object)
      end
    end

  end

  def duck(*methods)
    Matcher.new(methods) do |methods, object|
      methods.all? { |method| object.methods.include? method }
    end
  end

  private
  def match_lists?(list, list_to_compare, binding_object)
    match_list = true

    list.each_index do |i|
      if list[i].is_a?(Matcher) || list[i].is_a?(Symbol)
        match_list = match_list && list[i].call(list_to_compare[i], binding_object)
      else
        match_list = match_list && list[i] == list_to_compare[i]
      end
    end

    match_list
  end

end
