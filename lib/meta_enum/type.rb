require 'set'

module MetaEnum

  # ValueNormalizationError is raised on when a value normalization fails. It wraps the underlying exception.
  class ValueNormalizationError < StandardError
    attr_reader :original_exception, :original_value

    def initialize(original_exception, original_value)
      @original_exception = original_exception
      @original_value = original_value
    end

    def to_s
      "original_exception: #{original_exception}, original_value: #{original_value}"
    end
  end

  class Type
    attr_reader :elements, :elements_by_number, :elements_by_name

    # Initialize takes a single hash of name to number.
    #
    # e.g. MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    #
    # Additional data can also be associated with each value by passing an array
    # of [number, extra data]. This can be used for additional description or
    # any other reason.
    #
    # e.g. MetaEnum::Type.new(small: [0, "Less than 10], large: [1, "At least 10"]
    def initialize(
      elements,
      value_normalizer: method(:Integer)
    )
      @value_normalizer = value_normalizer
      @elements_by_number = {}
      @elements_by_name = {}
      @elements = Set.new

      elements.each do |name, number_and_data|
        number_and_data = Array(number_and_data)
        v = Element.new normalize_value(number_and_data[0]), name, number_and_data[1], self
        raise ArgumentError, "duplicate number: #{v.number}" if @elements_by_number.key? v.number
        raise ArgumentError, "duplicate name: #{v.name}" if @elements_by_name.key? v.name
        @elements_by_number[v.number] = v
        @elements_by_name[v.name] = v
        @elements.add(v)
      end

      @elements_by_number.freeze
      @elements_by_name.freeze
      @elements.freeze
      freeze
    end

    # [] is a "do what I mean" operator. It returns the Element from this type depending on the key.
    #
    # When key is a symbol, it is considered the name of the Element to return.
    # Since symbols are used from number, it is considered an error if the key is
    # not found and it raises an exception.
    #
    # When key can be converted to an integer by Integer(), then it is
    # considered the number of the Element to return. Retrieving by number is
    # presumed to converting from external data where a missing value should not
    # be considered fatal. In this case it returns a MissingElement is with number
    # as the key. This allows a Type to only specify the values is needs while
    # passing through the others unmodified.
    #
    # Finally, when key is a MetaEnum::Element, it is simply returned (unless it
    # belongs to a different Type in which case an ArgumentError is raised).
    #
    # See #values_by_number and #values_by_name for non-fuzzy value selection.
    def [](key)
      case key
      when Element, MissingElement
        raise ArgumentError, "wrong type" unless key.type == self
        key
      when Symbol
        elements_by_name.fetch(key)
      else
        key = normalize_value(key)
        elements_by_number.fetch(key) { MissingElement.new key, self }
      end
    end

    def inspect
      sprintf('#<%s: {%s}>', self.class, elements.to_a.map { |v| "#{v.name}: #{v.number}"}.join(", "))
    end

    def size
      elements.size
    end

  private
    def normalize_value(value)
      @value_normalizer.call(value)
    rescue StandardError => e
      raise ValueNormalizationError.new(e, value)
    end
  end
end
