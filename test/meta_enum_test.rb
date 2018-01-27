require "test_helper"

class MetaEnumTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil MetaEnum::VERSION
  end

  def test_type_constructor_without_data
    t = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    assert_equal 3, t.size
  end

  def test_type_constructor_with_data
    t = MetaEnum::Type.new(red: [0, "Red"], green: [1, "Green"], blue: [2, "Blue"])
    assert_equal 3, t.size
    assert_equal "Red", t[0].data
    assert_equal "Green", t[1].data
    assert_equal "Blue", t[2].data
  end

  def test_type_index_finds_by_symbol
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    red = type.elements_by_name[:red]
    assert_equal red, type[:red]
  end

  def test_type_index_raises_on_missing_symbol
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    assert_raises(KeyError) { type[:orange] }
  end

  def test_type_index_finds_by_number
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    red = type.elements_by_value[0]
    assert_equal red, type[0]
  end

  def test_type_index_finds_by_string_converted_to_value
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    red = type.elements_by_value[0]
    assert_equal red, type["0"]
  end

  def test_type_index_missing_value_converted_to_unknown_value
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    element = type[4]
    assert_equal 4, element.value
    assert_equal :missing_value, element.name
  end

  def test_type_index_finds_by_value
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    red = type.elements_by_name[:red]
    assert_equal red, type[red]
  end

  def test_element_equality_with_element
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    assert_equal type[:red], type[:red]
    refute_equal type[:red], type[:blue]
  end

  def test_element_equality_with_symbol
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    assert_equal type[:red], :red
    refute_equal type[:red], :blue
  end

  def test_element_equality_with_value
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    assert_equal type[0], 0
    refute_equal type[0], 1
  end

  def test_missing_value_equality
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    assert_equal type[42], type[42]
    refute_equal type[42], type[41]
  end

  def test_missing_element_equality_with_value
    type = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
    assert_equal type[42], 42
    refute_equal type[42], 17
    refute_equal type[42], 1
  end
end
