# frozen_string_literal: true

RSpec.describe RubyEars::Parser, type: :parser do
  Block = RubyEars::Parser::Block

  context "A single item list w/o body" do
    it "gets us a block" do
      expect(to_blocks("- single item")).to eq([{tag: :ul, content: [{tag: :li, content: ["single item"]}]}])
    end
  end

end
#  SPDX-License-Identifier: Apache-2.0
