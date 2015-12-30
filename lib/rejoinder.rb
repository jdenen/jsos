require "ostruct"
require "json"

class Rejoinder < OpenStruct
  def initialize(state = nil)
    state.is_a?(String) ? super(JSON.parse state) : super(state)
  end

  def empty?
    @table.empty?
  end
end
