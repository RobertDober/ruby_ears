module ParserSupport

  def expect_parsed(lines)
    expect(Ears::Parser.parse(lines))
  end

  private

end

RSpec.configure do |conf|
  conf.include ParserSupport, type: :parser
end
#  SPDX-License-Identifier: Apache-2.0
