RSpec.describe Ears::Scanner, type: :scanner do
  context "headers" do
    it "level 1, what else" do
      line = "# Level 1"
      assert_token line, headline(line:, content: "Level 1", level: 1)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
