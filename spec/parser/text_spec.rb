require "ruby_ears/parser"
RSpec.describe RubyEars::Parser, type: :parser do
  Block = RubyEars::Parser::Block

  context "Just text => a para" do
    it "gets us a block" do
      expect(to_blocks("simple_example")).to eq([Block::Para.new(lnb: 1, atts: {}, lines: ["simple_example"])])
    end
  end
end
