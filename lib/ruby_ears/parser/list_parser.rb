require_relative "../scanner"
require_relative "../parser/block"
require_relative "../parser/helper"
require_relative "list_parser/state"

module RubyEars
  module Parser
    module ListParser extend self
      include Helper
      def parse_list(input, result)
        input => [list_item, rest]
        state = State.new \
          list:  Block::List.make(list_item),
          list_item: list_item,
          rest_to_parse: [list_item, *rest]

        _parse_list(state) => {list:, rest_to_parse:}
        [rest_to_parse, [list, *result]]
      end

      private

      def _parse_list(state)
        state.rest_to_parse => [li, *rest]
        new_state =
          state
          .merge \
        header_content: [li.content],
        rest_to_parse: rest

        state1 = _parse_list_header(new_state)

        state2 =
          if state1.has_body
            parse_up_to(state1, _parse_body, _end_of_body)
          else
            state1
          end
        p(state2)

        state3 = _parse_list_body(state2)

        if state3.continues_list
          _parse_list(state3.reset_for_next_item)
        else
          state3.merge(list: _reverse_list_items(state3.list))
        end
      end

      def _parse_list_header(state)
        state => {list_item: li}

        state1 =
          parse_upto(state, _parse_header, _end_of_header)
        header_bock = Parser.parse(state1.header_content)

        state1.merge(header_block: header_block)
      end
    end
  end
end

#  SPDX-License-Identifier: Apache-2.0
