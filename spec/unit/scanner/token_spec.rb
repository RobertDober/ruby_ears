RSpec.describe Ears::Scanner do

  Pair = Ears::Pair
  Blank = Ears::Tokens::Blank

  context "spaces at the beginning of a line" do

    it "empty" do
      # expect(described_class.scan("", 42)).to eq(Pair.new(Blank.new(lnb: 42)))
      expect(described_class.scan("", 42)).to eq(Pair.new(token: Blank.new(lnb: 42)))
    end

  end
end
# SPDX-License-Identifier: Apache-2.0
