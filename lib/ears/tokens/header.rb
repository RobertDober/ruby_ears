# frozen_string_literal: true

module Ears
  module Tokens
    class Header
      include Token
      extend DataClass

      Rgx = /\A (\s*) (\#{1,6}) \s (.*) /x

      attributes :content, :level
      def self.make(line, lnb, match)
        match => _, spaces, headers, content
        new(line:, lnb:, content:, indent: spaces.length, level: headers.length)
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
