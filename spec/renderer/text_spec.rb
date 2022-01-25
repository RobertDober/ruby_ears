require "ruby_ears/parser"
RSpec.describe RubyEars::Parser, type: :parser do
  context "Empty" do
    it "returns empty" do
       expect(parse_ok("")).to be_empty
    end
  end
  context "Just text => a para" do
    it "simple example" do
      expect(parse_ok("simple example")).to eq([quad("p", "simple example")])
      # expect(parse_ok("simple example")).to eq([])
    end
  end
end
