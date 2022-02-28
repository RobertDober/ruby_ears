RSpec.describe Ears::Scanner, type: :scanner do
  context "spaces at the beginning of a line" do
    it "empty" do
      assert_token "", blank
    end

    it "still empty" do
      assert_token " ", blank(line: " ")
    end

    it "gets us text" do
      assert_token " a", text(line: " a", content: "a", indent: 1)
    end

    it "or an indent" do
      line = "    a"
      assert_token line, indent(line:, content: "a", indent: 4)
    end

    it "can indent even more" do
      line = "     a"
      assert_token line, indent(line:, content: "a", indent: 5)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
