module MetaEnum
  class MissingValue
    attr_reader :number, :type

    def initialize(number, type)
      @number = Integer(number)
      @type = type
      freeze
    end

    def name; :missing_value; end
    def data; nil; end

    def ==(other)
      other = type[other]
      number == other.number && type == other.type

    # type[] will raise for certain bad keys. Those are obviously not equal so return false.
    rescue ArgumentError, KeyError
      false
    end

    def to_i; number; end
    def to_s; name.to_s; end

    def inspect
      "#<#{self.class}: #{number}}>"
    end
  end
end
