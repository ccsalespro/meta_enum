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
      code == other.code && type == other.type
    end
  end
end
