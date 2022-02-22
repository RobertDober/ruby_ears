RSpec.describe Ears::Scanner, type: :scanner do
  context "ul" do
    context "-" do
      it "simple comme bonjour" do
        line = "- Hello"
        assert_token line, li(line:, bullet: "-", content: "Hello", list_indent: 2)
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
