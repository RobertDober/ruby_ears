require_relative "scanner"
require_relative "parser/block"
require_relative "parser/quad"
require_relative "parser/reader"
require_relative "renderer"

module RubyEars
  module Parser
    NoMethodError
    module_function def parse(lines)
      lines = lines.split("\n") if String === lines
      blocks, _links, options = lines_to_blocks(Scanner.scan_lines(lines.unshift("")))
      Renderer.render(blocks, options)
    end

    private

    module_function def lines_to_blocks(lines)
      _parse(lines, [])
    end

    module_function def _parse(lines, result)
      until lines.empty?
        lines, result = _parse_next(lines.shift, lines, result)
      end
      [result, nil, nil]
    end

    module_function def _parse_next(fst, rst, result)
      case fst
      when Scanner::Text
        _parse_text(fst, rst, result)
      when Scanner::Blank
        [result, rst]
      else
        raise NotImplementedError, "coming soon:\n\t#{fst.inspect}"
      end
    end

    module_function def _parse_text(fst, rst, result)
      reversed_para_lines, rest = _read_para_lines(rst, [fst])
      lines = reversed_para_lines
        .reverse
        .map(&:line)
      [Block::Para.new(lines: lines), rest]
    end

  end
end
