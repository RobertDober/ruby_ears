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
  end
end
#  SPDX-License-Identifier: Apache-2.0
