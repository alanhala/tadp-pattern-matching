class BindMethod
  def self.methods
    @@methods ||= {}
  end

  def self.define_method(name, &block)
    methods[name] = block
  end

  def self.clear_methods
    @@methods = {}
  end

  def self.method_missing(method_name, *args, &block)
    super unless methods[method_name]
    methods[method_name].call
  end
end
