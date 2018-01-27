module MetaEnum
  class MissingElement
    attr_reader :value, :type

    def initialize(value, type)
      @value = value
      @type = type
      freeze
    end

    def name; :missing_value; end
    def data; nil; end

    def ==(other)
      other = type[other]
      value == other.value && type == other.type

    # type[] will raise for certain bad keys. Those are obviously not equal so return false.
    rescue ArgumentError, KeyError
      false
    end

    def to_s; name.to_s; end

    def inspect
      "#<#{self.class}: #{value.inspect}}>"
    end
  end
end
