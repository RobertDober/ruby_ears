# frozen_string_literal: true

module Ears
  module Tokens
    class Indent
      include Token
      extend DataClass
      Rgx = /\A (\s{4,}) (.*) /x

      attributes :content

      def self.make(line, lnb, match)
        match => [_, spaces, content]
        new(content:, line:, lnb:, indent: spaces.length)
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
