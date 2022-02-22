RSpec.describe Ears::Scanner, type: :scanner do
  context "headers" do
    it "level 1, what else" do
      line = "# Level 1"
      assert_token line, headline(line:, content: "Level 1", level: 1)
    end

    it "detects backtix" do
      line = " ## Level 2`"
      assert_token line, headline(line:, content: "Level 2", level: 2, indent: 1), rest: "`"
    end
  end

  context "no headers, because..." do
    it "misses a space after the #" do
      line = "###Not a headline"
      assert_token line, text(line:, content: line)
    end
    it "has too many #s" do
      line = "####### Not a headline"
      assert_token line, text(line:, content: line)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
