require "ostruct"
require "json"

class JSOS < OpenStruct
  def initialize(state = nil)
    state.is_a?(String) ? super(JSON.parse state) : super(state)
  end

  def to_h
    @table.each_with_object({}) do |(key, value), new_hash|
      new_hash[key] = value.is_a?(JSOS) ? value.to_h : value
    end
  end

  def to_json
    self.to_h.to_json
  end

  def keys
    self.to_h.keys
  end

  def values
    self.to_h.values
  end

  def empty?
    @table.empty?
  end

  def method_missing methd, *args
    methd.to_s.end_with?('=') ? super(methd, *args) : super(make_setter(methd), JSOS.new)
  end

  private

  def make_setter getter
    getter.to_s.concat('=').to_sym
  end
end
