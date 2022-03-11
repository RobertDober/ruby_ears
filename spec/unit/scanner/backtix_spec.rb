RSpec.describe Ears::Scanner, type: :scanner do
  context "backtix" do
    # it "length 1" do
    #   line = "`rest"
    #   assert_token line, backtix(line:, content: "`", rest: "rest")
    # end

    it "length 2" do
      line = " ``"
      assert_token line, backtix, line:, content: "``", indent: 1, rest: "", length: 2
    end
  end

end
# SPDX-License-Identifier: Apache-2.0
