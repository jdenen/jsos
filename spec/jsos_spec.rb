require 'spec_helper'

describe JSOS do
  describe ".new" do
    context "without argument" do
      it "returns an empty JSOS object" do
        object = JSOS.new
        expect(object).to be_a JSOS
        expect(object).to be_empty
      end
    end

    context "with a valid JSON string argument" do
      it "parses into a JSOS object" do
        object = JSOS.new("{\"foo\":\"bar\"}")
        expect(object).to be_a JSOS
        expect(object).to_not be_empty
      end

      it "parses nested JSON into JSOS objects" do
        json = "{\"foo\":{\"abc\":\"123\"}}"
        object = JSOS.new(json)
        expect(object).to be_a JSOS
        expect(object.foo).to be_a JSOS
        expect(object.foo.abc).to eq "123"
      end

      it "parses a null JSON object into nil" do
        object = JSOS.new("{\"foo\":null}")
        expect(object).to be_a JSOS
        expect(object.foo).to be_nil
      end
    end

    context "when parsing an array of valid JSON objects" do
      let(:jsos){ JSOS.new("{\"abc\":[{\"foo\":\"bar\"}, {\"foo\":\"baz\"}]}") }
      
      it "parses each into a JSOS object" do
        expect(jsos.abc).to be_an(Array).and all(be_a JSOS)
      end

      it "can be chained to access array object values" do
        expect(jsos.abc.first.foo).to eq "bar"
      end
    end

    context "when parsing an array of non-JSON objects" do
      it "keeps the array structure"do
        object = JSOS.new("{\"abc\":[1, 2, 3]}")
        expect(object.abc).to be_an(Array).and all(be_a Fixnum)
      end
    end

    context "with an invalid JSON string argument" do
      it "raises a ParserError" do
        expect{ JSOS.new("foo") }.to raise_error(JSON::ParserError)
      end
    end

    context "with a Hash argument" do
      it "parses into a JSOS object" do
        object = JSOS.new({foo: "bar"})
        expect(object).to be_a JSOS
        expect(object).to_not be_empty
      end

      it "parses nested Hash into JSOS objects" do
        hash = {foo: {abc: "123"}}
        object = JSOS.new(hash)
        expect(object).to be_a JSOS
        expect(object.foo).to be_a JSOS
        expect(object.foo.abc).to eq "123"
      end

      it "parses a nil value" do
        object = JSOS.new(foo: nil)
        expect(object).to be_a JSOS
        expect(object.foo).to be_nil
      end
    end
  end

  describe "#to_h" do
    it "returns a Hash" do
      subject.foo = 'bar'
      expect(subject.to_h).to be_a Hash
      expect(subject.to_h).to eq({:foo => 'bar'})
    end

    it "converts nested JSOS objects into hashes"  do
      subject.foo = JSOS.new({:bar => 'baz'})
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

    context "when JSOS is empty" do
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

      context "when value is nil" do
        it "creates a getter method that returns nil" do
          expect(subject).to_not respond_to(:xyz)
          subject.xyz = nil
          expect(subject.xyz).to be_nil
        end
      end
    end

    context "when missing method is a getter" do
      it "creates the getter method" do
        expect(subject).to_not respond_to(:foo)
        subject.foo
        expect(subject).to respond_to(:foo)
      end
      
      it "sets the method equal to an empty JSOS" do
        expect(subject.foo).to be_a JSOS
      end
    end

    it "chain to create a nested object structure" do
      subject.abc.foo = 'bar'
      expect(subject).to respond_to(:abc)
      expect(subject.abc).to be_a JSOS
      expect(subject.abc.foo).to eq 'bar'
    end
  end

  describe "#each" do
    subject{ JSOS.new(:foo => "bar") }

    context "when given a block argument" do
      it "yields to a block" do
        expect{ |blk| subject.each(&blk) }.to yield_control
      end

      it "yields key, value pairs" do
        subject.abc = "xyz"
        expect{ |blk| subject.each(&blk) }.to yield_successive_args([:foo, "bar"], [:abc, "xyz"])
      end
    end

    context "when called on an empty object" do
      it "does not yield" do
        jsos = JSOS.new
        expect{ |blk| jsos.each(&blk) }.to_not yield_control
      end
    end
  end

  describe "#to_a" do
    subject{ JSOS.new(:foo => "bar", :abc => "xyz") }

    it "returns an array of arrays" do
      expect(subject.to_a).to be_an(Array).and all(be_an Array)
    end

    it "returns the method name and method value in each sub-array" do
      expect(subject.to_a.first).to eq [:foo, "bar"]
      expect(subject.to_a.last).to eq [:abc, "xyz"]
    end

    it "is aliased to #to_ary" do
      expect(subject.to_ary).to eq subject.to_a
    end
  end
end
