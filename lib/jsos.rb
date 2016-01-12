require "ostruct"
require "json"

#
# Parse or construct JSON strings with OpenStruct objects.
#
# @example
#   JSOS.new("{\"foo\":\"bar\"}")
#
# Setter methods add a key and a value to the object and are converted to JSON.
#
# @example
#   jsos = JSOS.new
#   jsos.foo = "bar"
#   jsos.to_json
#   #=> "{\"foo\":\"bar\"}"
#
# Getter methods represent the object keys and return their values.
#
# @example
#   jsos = JSOS.new("{\"foo\":\"bar\"}")
#   jsos.foo
#   #=> "bar"
#
# Undefined getter methods act like setter methods. Their values become empty JSOS objects.
#
# @example
#   jsos = JSOS.new
#   jsos.foo
#   jsos.to_json
#   #=> "{\"foo\":{}}"
#
# Undefined getters can be chained with setters to create nested JSON objects.
#
# @example
#   jsos = JSOS.new
#   jsos.abc.foo = "bar"
#   jsos.to_json
#   #=> "{\"abc\":{\"foo\":\"bar\"}}"
#
class JSOS < OpenStruct

  # @param state [String|Hash] defaults to nil
  def initialize(state = nil)
    return super if state.nil?
    state_hash = state.is_a?(String) ? JSON.parse(state) : state
    super parse_state_hash(state_hash)
  end

  # @return [Hash]
  def to_h
    @table.each_with_object({}) do |(key, value), new_hash|
      new_hash[key] = value.is_a?(JSOS) ? value.to_h : value
    end
  end

  # @return [String]
  def to_json
    self.to_h.to_json
  end

  # @return [Array<Symbol>]
  def keys
    self.to_h.keys
  end

  # @return [Array]
  def values
    self.to_h.values
  end

  def each &block
    self.to_h.each{ |k, v| yield k, v }
  end

  # @return [true|false]
  def empty?
    @table.empty?
  end

  private

  # @api private
  def method_missing methd, *args
    methd.to_s.end_with?('=') ? super(methd, *args) : super(make_setter(methd), JSOS.new)
  end

  # @api private
  def make_setter getter
    getter.to_s.concat('=').to_sym
  end

  # @api private
  def parse_state_hash state
    state.inject({}) do |hash, (key, value)|
      merge_value = value.is_a?(Hash) ? {key => JSOS.new(value)} : {key => value}
      hash.merge(merge_value)
    end
  end
end
