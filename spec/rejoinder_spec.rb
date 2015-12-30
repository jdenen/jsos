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

  describe "to_json" do
    it "returns a JSON string" do
      subject.foo = 'bar'
      expect(subject.to_json).to be_a String
      expect(subject.to_json).to eq "{\"foo\":\"bar\"}"
    end

    context "when Rejoinder is empty" do
      it "returns an empty JSON string" do
        expect(subject.to_json).to eq "{}"
      end
    end
  end

  describe "#keys" do
    it "returns top-level keys" do
      subject.foo = {:bar => 'baz'}
      expect(subject.keys).to eq [:foo]
    end
  end

  describe "#values" do
    it "returns top-level values" do
      subject.foo = {:bar => 'baz'}
      subject.one = 1
      expect(subject.values).to eq [{:bar => 'baz'}, 1]
    end
  end

  describe "missing methods" do
    context "when missing method is a setter" do
      it "creates the getter method" do
        expect(subject).to_not respond_to(:foo)
        subject.foo = 'bar'
        expect(subject).to respond_to(:foo)
        expect(subject.foo).to eq 'bar'
      end
    end

    context "when missing method is a getter" do
      it "creates the getter method" do
        expect(subject).to_not respond_to(:foo)
        subject.foo
        expect(subject).to respond_to(:foo)
      end
      
      it "sets the method equal to an empty Rejoinder" do
        expect(subject.foo).to be_a Rejoinder
      end
    end

    it "chain to create a nested object structure" do
      subject.abc.foo = 'bar'
      expect(subject).to respond_to(:abc)
      expect(subject.abc).to be_a Rejoinder
      expect(subject.abc.foo).to eq 'bar'
    end
  end
end
