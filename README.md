# JSOS

Use Ruby's OpenStruct object to represent JSON strings, making nested data a method call away.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsos

## Usage

JSOS turns a JSON string into an OpenStruct. It also allows you to construct JSON strings from scratch. Setter methods are turned into JSON keys and their arguments become the values. Getter methods return those values.

```ruby
# parsing JSON into OpenStruct
jsos = JSOS.new("{\"foo\":\"bar\"}")
jsos.foo
#=> "bar"

# parsing Hash into OpenStruct
jsos = JSOS.new({foo: "bar"})
jsos.foo
#=> "bar"

# creating an empty object and converting to JSON
jsos = JSOS.new
jsos.to_json
#=> "{}"

# adding to the empty JSON
jsos.foo = "bar"
jsos.to_json
#=> "{\"foo\":\"bar\"}"
```

A missing getter method is created with an empty JSOS object as its value. This allows you to chain methods to created nested JSON strings.

```ruby
# nesting empty JSON objects
jsos = JSOS.new
jsos.foo
jsos.to_json
#=> "{\"foo\":{}}"

# chaining methods to create nested JSON strings
jsos = JSOS.new
jsos.abc.foo = "bar"
jsos.xyz.foo = "baz"
jsos.to_json
#=> "{\"abc\":{\"foo\":\"bar\"}, \"xyz\":{\"foo\":\"baz\"}}"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jdenen/jsos.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

