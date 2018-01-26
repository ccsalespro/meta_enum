require 'set'

module MetaEnum
  class Type
    attr_reader :values, :values_by_code, :values_by_name

    # values is a array of hashes containing :code, :name, and optionally :data keys.
    def initialize(values)
      @values_by_code = {}
      @values_by_name = {}
      @values = Set.new

      values.each do |e|
        v = Value.new e.fetch(:code), e.fetch(:name), e[:data], self
        raise ArgumentError, "duplicate code: #{v.code}" if @values_by_code.key? v.code
        raise ArgumentError, "duplicate name: #{v.name}" if @values_by_name.key? v.name
        @values_by_code[v.code] = v
        @values_by_name[v.name] = v
        @values.add(v)
      end

      @values_by_code.freeze
      @values_by_name.freeze
      @values.freeze
      freeze
    end

    # [] is a "do what I mean" operator. It returns the Value from this type depending on the key.
    #
    # When key is a symbol, it is considered the name of the Value to return.
    # Since symbols are used from code, it is considered an error if the key is
    # not found and it raises an exception.
    #
    # When key can be converted to an integer by Integer(), then it is
    # considered the code of the Value to return. Retrieving by number is
    # presumed to converting from external data where a missing value should not
    # be considered fatal. In this case it returns a MissingValue is with code
    # as the key. This allows a Type to only specify the values is needs while
    # passing through the others unmodified.
    #
    # Finally, when key is a MetaEnum::Value, it is simply returned (unless it
    # belongs to a different Type in which case an ArgumentError is raised).
    #
    # See #values_by_code and #values_by_name for non-fuzzy value selection.
    def [](key)
      case key
      when Value
        raise ArgumentError, "wrong type" unless @values.include?(key)
        key
      when Symbol
        values_by_name.fetch(key)
      else
        key = Integer(key)
        values_by_code.fetch(key) { MissingValue.new key, self }
      end
    end
  end
end
