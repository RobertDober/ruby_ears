# frozen_string_literal: true

module Ears
  module Parser
    extend self
    include Tokens

    def parse(lines_or_string)
      state = State.make(lines_or_string)
      while state.token
        state = _parse(state)
      end
      state.ast
    end

    private

    def _parse(state)
      case state.token
      when Blank
        state.add(:eol)
      when Text
        state.add_text
      else
        raise SyntaxError, "unexpected input #{state.token.inspect}"
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
