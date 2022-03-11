# frozen_string_literal: true

module Ears
  module Tokens
    class Backtix
      include Token
      extend DataClass

      Rgx = /\A (\s*) (`+) (.*)/x

      attributes :content, :rest

      constraint :rest, String

      derive(:length) { _1.content.length }

      def self.make(line, lnb, match)
        match => _, spaces, content, rest
        new(line:, lnb:, content:, indent: spaces.length, rest:)
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
