require "test_helper"

class MetaEnumTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MetaEnum::VERSION
  end

  def colors_type
    ::MetaEnum::Type.new [
      {number: 0, name: :red},
      {number: 1, name: :green},
      {number: 2, name: :blue}
    ]
  end

  def test_type_index_finds_by_symbol
    type = colors_type
    red = type.values_by_name[:red]
    assert_equal red, type[:red]
  end

  def test_type_index_raises_on_missing_symbol
    type = colors_type
    assert_raises(KeyError) { type[:orange] }
  end

  def test_type_index_finds_by_number
    type = colors_type
    red = type.values_by_number[0]
    assert_equal red, type[0]
  end

  def test_type_index_finds_by_string_converted_to_number
    type = colors_type
    red = type.values_by_number[0]
    assert_equal red, type["0"]
  end

  def test_type_index_missing_number_converted_to_unknown_value
    type = colors_type
    value = type[4]
    assert_equal 4, value.number
    assert_equal :missing_value, value.name
  end

  def test_type_index_finds_by_value
    type = colors_type
    red = type.values_by_name[:red]
    assert_equal red, type[red]
  end

  def test_value_equality_with_value
    type = colors_type
    assert_equal type[:red], type[:red]
    refute_equal type[:red], type[:blue]
  end

  def test_value_equality_with_symbol
    type = colors_type
    assert_equal type[:red], :red
    refute_equal type[:red], :blue
  end

  def test_value_equality_with_number
    type = colors_type
    assert_equal type[0], 0
    refute_equal type[0], 1
  end

  def test_missing_value_equality
    type = colors_type
    assert_equal type[42], type[42]
    refute_equal type[42], type[41]
  end

  def test_missing_value_equality_with_number
    type = colors_type
    assert_equal type[42], 42
    refute_equal type[42], 17
    refute_equal type[42], 1
  end
end
