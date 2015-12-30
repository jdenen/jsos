require "ostruct"
require "json"

class Rejoinder < OpenStruct
  def initialize(state = nil)
    state.is_a?(String) ? super(JSON.parse state) : super(state)
  end

  def to_h
    @table.each_with_object({}) do |(key, value), new_hash|
      new_hash[key] = value.is_a?(Rejoinder) ? value.to_h : value
    end
  end

  def to_json
    self.to_h.to_json
  end

  def empty?
    @table.empty?
  end
end
