module RubyEars
  module Parser

    def _read_para_lines(rst, result)
      if rst.empty?
        [result.flatten, []]
      else
        head = rst.unshift
        case head
        when Scanner::Text, Scanner::TableLine
          _read_para_lines(rst, [head, result])
        else
          [result.flatten, rst]
        end
      end
    end
  end
end
