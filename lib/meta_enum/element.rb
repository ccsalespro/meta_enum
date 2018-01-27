module MetaEnum
  class Element
    attr_reader :value, :name, :data, :type

    def initialize(value, name, data, type)
      @value = value
      @name = name.to_sym
      @data = data
      @type = type
      freeze
    end

    def ==(other)
      equal?(other) || equal?(type[other])

    # type[] will raise for certain bad keys. Those are obviously not equal so return false.
    rescue ArgumentError, KeyError
      false
    end

    def to_s; name.to_s; end

    def inspect
      "#<#{self.class}: #{name}: #{value.inspect}, data: #{data.inspect}>"
    end
  end
end
