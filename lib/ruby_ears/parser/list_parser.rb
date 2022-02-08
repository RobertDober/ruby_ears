require_relative "../array"
require_relative "../scanner"
require_relative "../parser/block"
require_relative "../parser/helper"
require_relative "list_parser/state"

module RubyEars
  module Parser
    module ListParser extend self
      include Helper
      def parse_list(input, result)
        input => [list_item, *rest]
        state = State.new \
          list:  List.make(list_item),
          list_item: list_item,
          rest_to_parse: [list_item, *rest]

        _parse_list(state) => {list:, rest_to_parse:}
        [rest_to_parse, [list, *result]]
      end

      private

      def _behead(str, chars)
        str.sub(%r{\A\s{0, #{chars}}, "")
      end

      def _end_of_body
        -> state do
          return _finish_body(state) if state.rest_to_parse.empty?
          state => {rest_to_parse: [item, *]
                    return [:continue, state] if Line::Blank === item
                    return _finish_body(state) if Line::Heading === item
                    if item.indent < state.list.indent
                      _finish_body(state)
                    else
                      [:continue, state]
                    end
        end
      end

      def _parse_body(state)
        state => {rest_to_parse: [line, *rest], list:, result:}
        text = _behead(line.line, list.indent)
        line_ = Scanner.type_of(text, lnb: line.lnb)
        state.merge(rest_to_parse: rest, result: [line_, *result])
      end

      def _end_of_header
        -> state do
          if state.rest_to_parse.empty?
            return _finish_header(state)
          end
          state.rest_to_parse => [next_line, *rest]
          case next_line
            in Line::Blank
            _finish_header(state.merge(has_body: true, rest_to_parse: rest, spaced: true))
            in Line::ListItem
            _end_of_header_li(next_line.indent, state)
          else
            _end_of_header_other(next_line, rest, state)
          end
        end
      end

      def _end_of_header_li(current_indent, state)
        list_indent = state.list.indent
        if current_indent >= list_indent and current_indent < list_indent + 4
          _finish_header(state.merge(has_body?: true))
        else
          _finish_header(state)
        end
      end

      def _end_of_header_other(item, state)
        if item.indent >= state.list.indent
          return [:continue, state]
        end
        case item
          in Line::BlockQuote | Line::Heading | Line::Ruler
          _finish_header(state)
        else
          [:continue, state]
        end
      end

      def _finish_body(state)
        new_state = state.merge(
          result: state.result.reverse.drop_while(&Line::Blank))
        [:halt, new_state]
      end

      def _parse_header(
        -> state do
          state => {rest_to_parse: [line, *rest], header_content:}
          new_header_content = [line.line, *header_content]
          state.merge(
            header_content: new_header_content,
            rest_to_parse: rest)
        end
      end

      def _parse_list(state)
        state.rest_to_parse => [li, *rest]
        new_state =
          state
          .merge(
            header_content: [li.content],
            rest_to_parse: rest)

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

      # defp _parse_list_body(
      #        %State{
      #          header_block: header_block,
      #          list: list,
      #          list_item: li,
      #          options: options,
      #          rest_to_parse: rest,
      #          result: result
      #        } = state
      #      ) do
      #   {body_blocks, _, _, options1} = EarmarkParser.Parser.parse_lines(result, options, :list)

      #   continues_list? = _continues_list?(li, rest)

      #   loose? = list.loose? || (state.spaced? && (!Enum.empty?(result) || continues_list?))
      #   # if loose? do
      #   # require IEx; IEx.pry
      #   # end

      #   list_item = Block.ListItem.new(list, header_block ++ body_blocks)
      #   list1 = %{list | blocks: [list_item | list.blocks], loose?: list.loose? || loose?}
      #   %{state | continues_list?: continues_list?, list: list1, options: options1}
      # end
      def _parse_list_body(state)
        state
      end

      def _parse_list_header(state)
        state => {list_item: li}

        state1 =
          parse_upto(state, _parse_header, _end_of_header)
        header_block = Parser.parse(state1.header_content)

        state1.merge(header_block: header_block)
      end

      def _reverse_list_items(list)
        list.merge(blocks: _reverse_list_items_and_losen(list.blocks, list.is_loose))
      end

      def _reverse_list_items_and_losen(list_items, is_loose)
        list_items
          .inject [[], is_loose] do |(result, is_loose), list_item|
            is_loose ||= list_item.is_loose
            [[list_item.merge(is_loose:), *result], is_loose]
          end
            .first
      end
    end

  end
end

#  SPDX-License-Identifier: Apache-2.0
