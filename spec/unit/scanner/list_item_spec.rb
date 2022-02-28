RSpec.describe Ears::Scanner, type: :scanner do
  context "ul" do
    it "simple comme bonjour" do
      line = "- Hello"
      assert_token line, li(line:, bullet: "-", content: "Hello", list_indent: 2)
    end
    it "needs a space after the bullet" do
      line = "-Hello"
      assert_token line, text(content: line, line:)
    end
    it "can have a rest too" do
      line = " * `World`"
      assert_token line,
                   li(line:, bullet: "*", content: "", indent: 1, list_indent: 3),
                   rest: "`World`"
    end
    it "works with pluses and can have up to 4 spaces" do
      #      0....+....1
      line = "  +    Universe"
      assert_token line, li(line:, bullet: "+", content: "Universe", indent: 2, list_indent: 7)
    end
    it "but no more than 4 spaces" do
      #      0....+....1
      line = "  +     Cosmos"
      assert_token line, text(content: "+     Cosmos", indent: 2, line:)
    end
    it "indents still rule" do
      line = "    - just indent"
      assert_token line, indent(content: "- just indent", line:, indent: 4)
    end
  end

  context "ol" do
    it "needs a dot" do
      line = "1. First"
      assert_token line, li(line:, bullet: "1.", content: "First", list_indent: 3, start: 1)
    end
    it "can also use parens and start much higher" do
      line = "  123456789) Last"
      assert_token line,
                   li(line:, bullet: "123456789)", content: "Last", indent: 2, list_indent: 13, start: 123_456_789)
    end
    it "must, however not exceed nine digits, bummer" do
      line = "1234567890) Text"
      assert_token line, text(content: line, line:)
    end
    it "can start with 0" do
      line = "0. where else?"
      assert_token line, li(line:, bullet: "0.", content: "where else?", list_indent: 3, start: 0)
    end
    it "and, of course, indents still rule" do
      line = "     1. just indent"
      assert_token line, indent(content: "1. just indent", line:, indent: 5)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
