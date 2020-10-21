require 'ostruct'
require_relative "scanner/blank"
require_relative "scanner/html_comment"
require_relative "scanner/list_item"
module RubyEars
  module Scanner
    module_function

    HtmlCompleteCommentRgx = %r{\A (\s{0,3}) <! (?: -- .*? -- \s* )+ > \z}x
    HtmlIncompleteCommentRgx = %r{ \A (\s{0,3}) <!-- .*? \z}x
    ListItemRgx = %r{ \A (\s{0,3}) ([-*+]) (\s+) (.*) }x

    def type_of(line, lnb: 42)
      case line
      when ListItemRgx
        return _make_list_item(Regexp.last_match, line)
      when HtmlCompleteCommentRgx
        return HtmlComment.new(
          complete: true,
          indent: Regexp.last_match[1].size,
          line: line,
          lnb: lnb)
      when HtmlIncompleteCommentRgx
        return HtmlComment.new(
          complete: false,
          indent: Regexp.last_match[1].size,
          line: line,
          lnb: lnb)
      else
        return Blank.new(lnb: lnb)
      end
    end


    private

    module_function
    def _compute_list_indent(match)
      sl = match[3].size
      match[1].size + match[2].size + (sl > 4 ? 1 : sl)
    end

    module_function
    def _make_list_item(match, line)
      # [_, leading, bullet, spaces, text] = match
      ListItem.new(
        bullet: match[2],
        content: match[4],
        indent: match[1].size,
        initial_indent: 0,
        line: line,
        list_indent: _compute_list_indent(match),
        lnb: 42,
        type: :ul)
    end
  end
end
