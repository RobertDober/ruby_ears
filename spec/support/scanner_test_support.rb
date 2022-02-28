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
      Ears::Tokens::Indent.new(**_args(args))
    end

    def li(**args)
      Ears::Tokens::ListItem.new(**_args(args))
    end

    def th_break(**args)
      args[:content] = args[:line].gsub(" ", "")
      args[:indent] = 0
      Ears::Tokens::ThematicBreak.new(**_args(args))
    end

    def text(**args)
      Ears::Tokens::Text.new(**_args(args))
    end

    def _args(args)
      {content: args[:line].lstrip, indent: args[:line][/^\s*/].length, lnb: 0}.merge(args)
    end
  end
end

RSpec.configure do |conf|
  conf.include Support::ScannerTest, type: :scanner
end
#  SPDX-License-Identifier: Apache-2.0
