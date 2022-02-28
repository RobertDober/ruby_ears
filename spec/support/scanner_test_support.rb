module Support
  module ScannerTest
    def assert_token(input, token, rest: :eol, lnb: 0)
      result = Ears::Scanner.scan(input, lnb)
      expected = Pair(token, rest)
      expect(result).to eq(expected)
    end

    def blank(**args)
      Ears::Tokens::Blank.new(**args)
    end

    def headline(**args)
      Ears::Tokens::Header.new(**args)
    end

    def indent(**args)
      Ears::Tokens::Indent.new(**_with_content(args))
    end

    def li(**args)
      Ears::Tokens::ListItem.new(**_with_indent(args))
    end

    def th_break(**args)
      Ears::Tokens::ThematicBreak.new(**args)
    end

    def text(**args)
      Ears::Tokens::Text.new(**_with_content(args))
    end

    private

    def _with_indent(args)
      { indent: args[:line][/^\s*/].length, lnb: 0 }.merge(args)
    end

    def _with_content(args)
      { content: args[:line].lstrip }.merge(_with_indent(args))
    end
  end
end

RSpec.configure do |conf|
  conf.include Support::ScannerTest, type: :scanner
end
#  SPDX-License-Identifier: Apache-2.0
