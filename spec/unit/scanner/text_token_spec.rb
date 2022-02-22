RSpec.describe Ears::Scanner, type: :scanner do
  context "just text" do
    it "will return the whole line" do
      line = "some # text"
      assert_token line, text(line:, content: line)
    end

    it "will not break on escaped backtix" do
      line = "escaped \\`"
      assert_token line, text(line:, content: line)
    end
  end

  context "breaking up the line" do
    it "if we have backtix" do
      line = "some `inline"
      assert_token line, text(line:, content: "some "), rest: "`inline"
    end
    it "if we have escaped backtix followed by unescaped" do
      line = "escaped \\`` or not?"
      assert_token line, text(line:, content: "escaped \\`"), rest: "` or not?"
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
