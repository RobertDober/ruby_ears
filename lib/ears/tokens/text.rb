# frozen_string_literal: true

module Ears
  module Tokens
    class Text
      include Token
      extend DataClass

      LeadingSpacesRgx = /\A (\s*) (.*) /x

      def self.make(line, lnb)
        LeadingSpacesRgx.match(line) => [_, spaces, content]
        new(content:, indent: spaces.length, line:, lnb:)
      end

      attributes :content
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
