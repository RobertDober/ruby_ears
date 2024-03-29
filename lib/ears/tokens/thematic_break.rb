# frozen_string_literal: true

module Ears
  module Tokens
    class ThematicBreak
      include Token
      extend Lab42::DataClass # must be last in extension list

      BreakTypes = { "*" => :thick, "_" => :medium, "-" => :thin }.freeze
      Rgx = /\A \s* ([-_*]) (?:\s*\1){2,} \s* \z/x

      def self.make(line, lnb, match)
        match => [_, type_str]
        type = BreakTypes[type_str]
        new(line:, lnb:, type:)
      end

      attributes :type
      constraint :type, Set.new(BreakTypes.values)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
