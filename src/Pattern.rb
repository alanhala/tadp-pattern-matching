def val(val)
  MatcherValue.new(val)
end


def type(type)
  MatcherType.new(type)
end


class MatcherValue

  attr_accessor :val

  def initialize(val)
    self.val = val
  end

  def call(otherValue)
    self.val == otherValue
  end

end


class MatcherType

  attr_accessor :type

  def initialize(type)
    self.type = type
  end

  def call(value)
    value.class.ancestors.include? self.type
  end

end