# frozen_string_literal: true

module Ears
  module Tokens
    class ListItem
      include Token
      extend DataClass

      Bullets = [
        "\\*", "-", "\\+", "\\d{1,9}(?:\\.|\\))"
      ].join("|").freeze
      Rgx = /\A (\s*) (#{Bullets}) (\s{1,4}(?=\S)) (.*) /x

      def self.make(line, lnb, match)
        match => [_, spaces, bullet, li_space, content]
        list_indent = spaces.length + bullet.length + li_space.length
        new(bullet:, content:, list_indent:)
      end

      attributes :bullet, :content, :list_indent
      derive :start do
        if _1.bullet.end_with?(".") || _1.bullet.end_with?(")")
          _1.bullet.to_i
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
