# frozen_string_literal: true

require "lab42/data_class/builtin_constraints"

module Ears
  module Parser
    class State
      extend ClassMethods
      extend DataClass

      attributes ast: Nil, input: [], lnb: 0, messages: Set.new, needed_indent: 0, token: nil

      constraint :ast, ListOf(Choice(Ast::Node, Symbol))

      def add(element)
        set(:ast)
        .cons(element)
        .advance
      end

      def advance
        case input
        in []
          merge(token: nil)
        in [current_line, *rest]
          case Scanner.scan(current_line, lnb - 1)
          in Pair(token, :eol)
            merge(input: rest, lnb: lnb + 1, token:)
          in Pair(token, trailing)
            merge(input: [trailing, *rest], token:)
          end
        end
      end
    end
  end
end
