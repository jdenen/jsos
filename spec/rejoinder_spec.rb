require 'spec_helper'

describe Rejoinder do
  describe ".new" do
    context "without argument" do
      it "returns an empty Rejoinder object" do
        object = Rejoinder.new
        expect(object).to be_a Rejoinder
        expect(object).to be_empty
      end
    end

    context "with a valid JSON string argument" do
      it "parses into a Rejoinder object" do
        object = Rejoinder.new("{\"foo\":\"bar\"}")
        expect(object).to be_a Rejoinder
        expect(object).to_not be_empty
      end
    end

    context "with an invalid JSON string argument" do
      it "raises a ParserError" do
        expect{ Rejoinder.new("foo") }.to raise_error(JSON::ParserError)
      end
    end

    context "with a Hash argument" do
      it "parses into a Rejoinder object" do
        object = Rejoinder.new({foo: "bar"})
        expect(object).to be_a Rejoinder
        expect(object).to_not be_empty
      end
    end
  end

  describe "#to_h" do
    it "returns a Hash" do
      subject.foo = 'bar'
      expect(subject.to_h).to be_a Hash
      expect(subject.to_h).to eq({:foo => 'bar'})
    end

    it "converts nested Rejoinder objects into hashes"  do
      subject.foo = Rejoinder.new({:bar => 'baz'})
      expect(subject.to_h[:foo]).to be_a Hash
      expect(subject.to_h[:foo][:bar]).to eq 'baz'
    end
  end
end
