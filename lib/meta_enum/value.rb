module MetaEnum
  class Value
    attr_reader :number, :name, :data, :type

    def initialize(number, name, data, type)
      @number = number
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

    def to_i; number; end
    def to_s; name.to_s; end

    def inspect
      "#<#{self.class}: #{name}: #{number}, data: #{data.inspect}>"
    end
  end
end
