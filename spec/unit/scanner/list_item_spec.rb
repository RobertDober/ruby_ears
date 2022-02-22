RSpec.describe Ears::Scanner, type: :scanner do
  context "ul" do
    context "-" do
      it "simple comme bonjour" do
        line = "- Hello"
        assert_token line, li(line:, bullet: "-", content: "Hello", list_indent: 2)
      end
      it "can have a rest too" do
        line = " * `World`"
        assert_token line,
                     li(line:, bullet: "*", content: "", indent: 1, list_indent: 3),
                     rest: "`World`"
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
