module MetaEnum
  class MissingValue
    attr_reader :code, :type

    def initialize(code, type)
      @code = Integer(code)
      @type = type
      freeze
    end

    def name; :missing_value; end
    def data; nil; end

    def ==(other)
      other = type[other]
      code == other.code && type == other.type

    # type[] will raise for certain bad keys. Those are obviously not equal so return false.
    rescue ArgumentError, KeyError
      false
    end
  end
end
