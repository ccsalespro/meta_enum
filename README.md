# MetaEnum

MetaEnum is a library for handling enum types in Ruby. It makes it easy to
convert between external values and internal names.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'meta_enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install meta_enum

## Usage

Create a enum type:

```ruby
require 'meta_enum'

ColorType = MetaEnum::Type.new(red: 0, green: 1, blue: 2)
```

Use the `[]` operator to lookup a value by name:

```ruby
ColorType[:green] # => #<MetaEnum::Element: 1 => green}>
```

Or lookup by number:

```ruby
ColorType[1] # => #<MetaEnum::Element: 1 => green}>
```

Elements can also be easily compared with values or names:

```ruby
ColorType[:green] == 1 # => true
ColorType[:green] == :green # => true
```

Missing names would almost always be a programming error, so that will raise an exception.

```ruby
ColorType[:purple] # => raises: KeyError: key not found: :purple
```

But missing values could mean that there are values defined externally we do not know about. So it is preferable not to raise an exception.

```ruby
ColorType[42] # => #<MetaEnum::MissingElement: 42}>
```

Value and name can be retrieved from a `MetaEnum::Element`

```ruby
v = ColorType[:red] # => #<MetaEnum::Element: 0 => red}>
v.value # => 0
v.name # => :red
```

Values can have extra associated data.

```ruby
AgeType = MetaEnum::Type.new(child: [0, "Less than 18"], adult: [1, "At least 18"])
AgeType[:child].data # => "Less than 18"
```

Non-integer values can be enabled by passing a value_normalizer to `MetaEnum::Type.new`. For example, to use string values:

```ruby
CardType = MetaEnum::Type.new({visa: "VS", mastercard: "MC", discover: "DS"}, value_normalizer: method(:String))
CardType[:visa] # => #<MetaEnum::Element: visa: "VS", data: nil>
CardType["VS"] # => #<MetaEnum::Element: visa: "VS", data: nil>
pry(main)> CardType["VS"].value # => "VS"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ccsalespro/meta_enum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
