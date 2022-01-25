require_relative "scanner"
require_relative "parser/block"
require_relative "parser/list_parser"
require_relative "parser/quad"
require_relative "parser/reader"
require_relative "renderer"

module RubyEars
  module Parser extend self

    def lines_to_blocks(lines)
      _parse(lines, [])
    end

    def parse(lines)
      lines = lines.split("\n") if String === lines
      blocks, _links, options = lines_to_blocks(Scanner.scan_lines(lines.unshift("")))
      Renderer.render(blocks, options)
    end

    private

    def _parse(lines, result)
      until lines.empty?
        lines, result = _parse_next(lines.shift, lines, result)
      end
      [result, nil, nil]
    end

    def _parse_next(fst, rst, result)
      case fst
      when Scanner::Text
        _parse_text(fst, rst, result)
      when Scanner::Heading
        _parse_heading(fst, rst, result)
      when Scanner::Blank
        [rst, result]
      when Scanner::ListItem
        RubyEars::Parser::ListParser.parse_list(fst, rst, result)
      else
        raise NotImplementedError, "coming soon:\n\t#{fst.inspect}"
      end
    end

    def _parse_heading(fst, rst, result)
      [rst, Block::Heading.new(content: fst.content, level: fst.level, lnb: fst.lnb.succ)]
    end

    def _parse_text(fst, rst, result)
      reversed_para_lines, rest = _read_para_lines(rst, [fst])
      lines = reversed_para_lines
        .reverse
        .map(&:line)
      [rest, result.unshift(Block::Para.new(lines: lines, lnb: fst.lnb.succ))]
    end

  end
end
#  SPDX-License-Identifier: Apache-2.0
