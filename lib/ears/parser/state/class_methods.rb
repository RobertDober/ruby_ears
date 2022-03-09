# frozen_string_literal: true

module Ears
  module Parser
    class State
      module ClassMethods
        def make(lines_or_strings)
          case _make_lines(lines_or_strings)
          in [current_line, *rest]
            _make_with_token(current_line, rest)
          else
            new
          end
        end

        private
        def _make_lines(lines_or_strings)
          case lines_or_strings
          when String
            lines_or_strings.split("\n")
          when Array
            lines_or_strings
          else
            raise ArgumentError, "Illegal input #{lines_or_string} is neither an Array nor a String"
          end
        end

        def _make_with_token(current_line, rest)
          case Scanner.scan(current_line, 1)
          in Pair(token, :eol)
            new(input: rest, lnb: 2, token:)
          in Pair(token, trailing)
            new(input: [trailing, *rest], lnb: 1, token:)
          end
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
