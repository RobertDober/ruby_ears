# frozen_string_literal: true

require 'ruby_ears/array'
RSpec.describe Array do
  describe "reverse_inject" do
    let :concatenator do
      -> acc, ele do
        [acc, ele].join
      end
    end

    context "edge cases" do
      it "empty" do
        expect([].reverse_inject(0){ raise "Error" }).to eq(0)
      end
      it "one element" do
        expect([:a].reverse_inject("b", &concatenator)).to eq("ba")
      end
    end

    context "real cases" do
      it "takes last element first ...." do
        expect([:a, :b, :c].reverse_inject("X", &concatenator))
          .to eq("Xcba")
      end
    end
  end
end

#  SPDX-License-Identifier: Apache-2.0
