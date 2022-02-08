# frozen_string_literal: true

RSpec.describe RubyEars::Parser, type: :parser do
  Block = RubyEars::Parser::Block

  context "A single item list w/o body" do
    it "gets us a block" do
      expect(to_blocks("- single item")).to eq([{tag: :ul, content: [{tag: :li, content: ["single item"]}]}])
    end
  end

  context "A single item with a body" do
    it "gets us two paragraphs" do
      input = <<-EOM
      * Hello

        World
      EOM
      expected = [
        ul(li(p("Hello"), p("World")))
      ]
      expect(to_blocks(input)).to eq([{tag: :ul, content: [{tag: :li, content: ["single item"]}]}])
    end
  end

end
#  SPDX-License-Identifier: Apache-2.0
