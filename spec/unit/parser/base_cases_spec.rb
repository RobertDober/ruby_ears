RSpec.describe Ears::Parser, type: :parser do
  context "empty input" do
    it "parses an empty string" do
      expect_parsed("").to eq(Nil)
    end
    it "parses an empty array" do
      expect_parsed([]).to eq(Nil)
    end
    it "parses a blank string" do
      expect_parsed(" ").to eq(List(:eol))
    end
  end

  context "text" do
    it "parses a line of text" do
      expect_parsed("alpha").to eq(List("alpha"))
    end
    it "parses some line of text" do
      expect_parsed(%w[alpha beta]).to eq(List("alpha\nbeta"))
    end
    it "ignores leading ws" do
      expect_parsed(["", "alpha", "beta"]).to eq(List("alpha\nbeta"))
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
