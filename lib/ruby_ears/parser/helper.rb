# frozen_string_literal: true
module RubyEars
  module Parser
    module Helper
      def parse_upto(state, parse_fn, term_fn)
        loop do
          case term_fn.(state)
            in [:continue, state_]
              state = parse_fn.(state_)
            in [:halt, state_]
              return state_
            in x
              raise "Illegal return value: #{x} from #{term_fn}"
          end
        end
      end
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
