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
    attr_reader :elements, :elements_by_value, :elements_by_name

    # Initialize takes a single hash of name to value.
    #
    # e.g. MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    #
    # Additional data can also be associated with each value by passing an array
    # of [value, extra data]. This can be used for additional description or
    # any other reason.
    #
    # e.g. MetaEnum::Type.new(small: [0, "Less than 10], large: [1, "At least 10"]
    #
    # value_normalizer is a callable object that normalizes values. The default
    # converts all values to integers. To allow string values use method(:String).
    #
    # element_class is the class with which to create elements. It should be a
    # sub-class of MetaEnum::Element (or otherwise match it's behavior).
    def initialize(
      elements,
      value_normalizer: method(:Integer),
      element_class: MetaEnum::Element
    )
      @value_normalizer = value_normalizer
      @elements_by_value = {}
      @elements_by_name = {}
      @elements = Set.new

      elements.each do |name, value_and_data|
        value_and_data = Array(value_and_data)
        v = element_class.new normalize_value(value_and_data[0]), name, value_and_data[1], self
        raise ArgumentError, "duplicate value: #{v.value}" if @elements_by_value.key? v.value
        raise ArgumentError, "duplicate name: #{v.name}" if @elements_by_name.key? v.name
        @elements_by_value[v.value] = v
        @elements_by_name[v.name] = v
        @elements.add(v)
      end

      @elements_by_value.freeze
      @elements_by_name.freeze
      @elements.freeze
      freeze
    end

    # [] is a "do what I mean" operator. It returns the Element from this type depending on the key.
    #
    # When key is a symbol, it is considered the name of the Element to return.
    # Since symbols are used from code, it is considered an error if the key is
    # not found and it raises an exception.
    #
    # When key can be converted to an integer by value_normalizer, then it is
    # considered the value of the Element to return. Retrieving by value is
    # presumed to converting from external data where a missing value should not
    # be considered fatal. In this case it returns a MissingElement is with value
    # as the key. This allows a Type to only specify the values it needs while
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
        elements_by_value.fetch(key) { MissingElement.new key, self }
      end
    end

    def inspect
      sprintf('#<%s: {%s}>', self.class, elements.to_a.map { |v| "#{v.name}: #{v.value}"}.join(", "))
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
