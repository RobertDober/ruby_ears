RSpec.describe Ears::Scanner, type: :scanner do
  context "thematic break" do
    it "with *" do
      line = "***"
      assert_token line, th_break(line:, type: :thick)
    end
    it "with -" do
      line = "---"
      assert_token line, th_break(line:, type: :thin)
    end
    it "with _" do
      line = "___"
      assert_token line, th_break(line:, type: :medium)
    end
    it "One space ok" do
      line = " ***"
      assert_token line, th_break(line:, type: :thick)
    end
    it "Two spaces ok" do
      line = "  ***"
      assert_token line, th_break(line:, type: :thick)
    end
    it "Three spaces ok" do
      line = "   ***"
      assert_token line, th_break(line:, type: :thick)
    end
    it "long" do
      line = "_____________________________________"
      assert_token line, th_break(line:, type: :medium)
    end
    it "spaced" do
      line = " - - -"
      assert_token line, th_break(line:, type: :thin)
    end
    it "is this morse?" do
      line = " **  * ** * ** * **"
      assert_token line, th_break(line:, type: :thick)
    end
    it "whatever you say" do
      line = "-     -      -      -"
      assert_token line, th_break(line:, type: :thin)
    end
    it "trailing spaces, how ugly" do
      line = "- - - -    "
      assert_token line, th_break(line:, type: :thin)
    end
  end

  context "not a thematic break" do
    it "two thins" do
      line = "--"
      assert_token line, text(line:)
    end
    it "two thicks" do
      line = "**"
      assert_token line, text(line:)
    end
    it "two mediums" do
      line = "__"
      assert_token line, text(line:)
    end
    it "three equals" do
      line = "==="
      assert_token line, text(line:)
    end
    it "three pluses" do
      line = "+++"
      assert_token line, text(line:)
    end
    it "indent" do
      line = "    ***"
      assert_token line, indent(line:)
    end
    it "x at the end, spoils it all" do
      line = "- - - - x   "
      assert_token line, li(line:, content: line[2..], list_indent: 2, bullet: "-")
    end
    it "x at the beginning, spoils it all" do
      line = " x - - - -   "
      assert_token line, text(line:)
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
