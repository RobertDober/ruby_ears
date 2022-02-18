RSpec.describe "Ears::VERSION" do
  let(:version) { Ears::VERSION }
  it "is a frozen string" do
    expect(version).to be_frozen
  end

  it "is a semantic version" do
    expect(version).to match(/\A \d+ \. \d+ \. \d+/x)
  end
end
# SPDX-License-Identifier: Apache-2.0
