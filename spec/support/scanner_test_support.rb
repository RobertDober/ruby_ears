module Support
  module ScannerTest

    DefaultValues = {
      ann: nil,
      ial: nil,
      lnb: 0,
      rest: :eol
    }
    def assert_token line, type, **values
      values_with_defaults =
        DefaultValues.merge(values)
      result = Ears::Scanner.scan(line, values_with_defaults[:lnb])
      expect(result.first).to be_kind_of(type)
      expect(result.first.to_h).to eq(values_with_defaults)
      expect(result.second).to eq(values_with_defaults[:rest])
    end


    # def backtix(**args)
    #   Ears::Tokens::Backtix.new(**args)
    # end


  end
end

module ImportTokens
  extend self
  SplitterRgx = /([[:upper:]])/
  def underscore(name)
    name
      .to_s
      .split(SplitterRgx) => _, *parts
    parts
      .each_slice(2)
      .map(&:join)
      .join("_")
      .downcase
  end

  Ears::Tokens.constants.each do |konst|
    value = Ears::Tokens.const_get(konst)
    module_eval do
      define_method underscore(konst) do
        value
      end
    end
  end
end

RSpec.configure do |conf|
  conf.include Support::ScannerTest, type: :scanner
  conf.include ImportTokens
end
#  SPDX-License-Identifier: Apache-2.0
