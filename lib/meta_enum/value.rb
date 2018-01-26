module MetaEnum
  class Value
    attr_reader :code, :name, :data, :type

    def initialize(code, name, data, type)
      @code = Integer(code)
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
  end
end
