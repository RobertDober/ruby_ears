require 'ostruct'
require_relative "scanner/line_types"
module RubyEars
  module Scanner
    module_function

    BlankRgx                  = %r{\A \s* \z}x
    BlockQuoteRgx             = %r{\A (\s{0,3}) >(?:(\s*)|\s?(.*)) \z}x
    HeadingRgx                = %r{\A (\#{1,6}) \s+ (.*) \z}x
    HtmlCompleteCommentRgx    = %r{\A (\s{0,3}) <! (?: -- .*? -- \s* )+ > \z}x
    HtmlIncompleteCommentRgx  = %r{ \A (\s{0,3}) <!-- .*? \z}x
    IalRgx                    = %r<\A (\s{0,3}) {:(\s*[^}]+)} \s* \z>x
    IdTitlePartRgx            = %r{
    (?:
     " (?<title>.*)  "         # in quotes
     |  ' (?<title>.*)  '         #
     | \( (?<title>.*) \)         # in parens
    )? }x
     IdRgx                     = %r{
    \A (?<leading>\s{0,3})
    \[(?<id>\S*?)\]:
    \s+
      (?:
       < (?<url>\S+) >
       | (?<url>\S+)
      )
    \s*
         #{IdTitlePartRgx}
      \s*
      \z }x
      ListItemOlRgx             = %r{\A (\s{0,3}) (\d{1,9} [.)]) \s(\s*) (.*)}x
    ListItemUlRgx             = %r{ \A (\s{0,3}) ([-*+]) \s (\s*) (.*) }x
    RulerAsterixRgx           = %r{ \A (\s{0,3}) (?:\*\s?){3,} \z}x
    RulerDashRgx              = %r{ \A (\s{0,3}) (?:-\s?){3,} \z}x
    RulerUnderscoreRgx        = %r{ \A (\s{0,3}) (?:_\s?){3,} \z}x
    SetextUnderlineHeadingRgx = %r{ \A (=|-)+ \s* \z}x
    TableColumnRgx            = %r{\A [\s|:-]+ \z}x
    TableLineRgx              = %r{\A (\s{0,3}) \| (?: [^|]+ \|)+ \s* \z}x
    TableLineGfmRgx           = %r{\A (\s*) .* \s \| \s }x

    TextRgx                   = %r{ \A (\s*) (.*)  }x

    def type_of(line, lnb: 42)
      case line
      when RulerDashRgx
        return Ruler.new(
          indent: Regexp.last_match[1].size,
          line: line,
          lnb: lnb,
          type: "-"
        )
      when RulerAsterixRgx
        return Ruler.new(
          indent: Regexp.last_match[1].size,
          line: line,
          lnb: lnb,
          type: "*"
        )
      when RulerUnderscoreRgx
        return Ruler.new(
          indent: Regexp.last_match[1].size,
          line: line,
          lnb: lnb,
          type: "_"
        )
      when IdRgx
        return _make_id_ref(Regexp.last_match, lnb)
      when ListItemOlRgx
        return _make_ol_list_item(Regexp.last_match, lnb)
      when ListItemUlRgx
        return _make_ul_list_item(Regexp.last_match, lnb)
      when TableLineRgx
        return _make_table_line(Regexp.last_match, lnb)
      when TableLineGfmRgx
        return _make_table_gfm_line(Regexp.last_match, lnb)
      when IalRgx
        return _make_ial(Regexp.last_match, lnb)
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
      when SetextUnderlineHeadingRgx
        level = Regexp.last_match[1][0] == "=" ? 1 : 2
        return SetextUnderlineHeading.new(
          level: level,
          line: line,
          lnb: lnb)
      when HeadingRgx
        return _make_heading(Regexp.last_match, lnb)
      when BlankRgx
        return Blank.new(lnb: lnb)
      when TextRgx
        return _make_text(Regexp.last_match, lnb)
      end
      raise "Ooops no such line type #{line.inspect}"
    end


    private

    module_function def _compute_list_indent(match)
      sl = match[3].size
      match[1].size + match[2].size + (sl > 4 ? 1 : sl)
    end

    module_function def _make_heading(match, lnb)
      Heading.new(
        content: match[2],
        level: match[1].size,
        line: match.string,
        lnb: lnb)
    end

    module_function def _make_ial(match, lnb)
      # %r<\A (\s{0,3}) {:(\s*[^}]+)} \s \z>x
      leading, ial = match.captures
      Ial.new(attrs: ial.strip, indent: leading.size, lnb: lnb, line: match.string, verbatim: ial)
    end

    module_function def _make_id_ref(match, lnb)
      leading, id, url, title = match.named_captures.values_at(*%w[leading id url title])
      IdDef.new(id: id, url: url, title: title, indent: leading.size, line: match.string, lnb: lnb)
    end

    module_function def _make_ol_list_item(match, lnb)
      leading, bullet, spaces = match.values_at(1, 2, 3)
      sl = spaces.size
      sl1 = sl > 3 ? 1 : sl.succ
      sl2 = sl1 + bullet.size
      ListItem.new(
        type: :ol,
        bullet: bullet,
        content: match.values_at(3,4).join,
        indent: leading.size,
        line: match.string,
        list_indent:  leading.size + sl2,
        lnb: lnb)
    end
    module_function def _make_ul_list_item(match, lnb)
      leading, bullet, spaces = match.values_at(1, 2, 3)
      ListItem.new(
        bullet: bullet,
        content: match.values_at(3, 4).join,
        indent: leading.size,
        initial_indent: 0,
        line: match.string,
        list_indent: match.values_at(1, 2, 3).join.size.succ,
        lnb: lnb,
        type: :ul)
    end

    module_function def _make_table_line match, lnb
      leading = match[1]
      body = match
        .string
        .strip
        .sub(%r{\A\|+},"")
        .sub(%r{\|+\z},"")

      columns = _split_table_columns(body)

      TableLine.new(
        columns: columns,
        content: match.string,
        indent: leading.size,
        is_header: _determine_if_header(columns),
        line: match.string,
        lnb: lnb)
    end

    module_function def _make_table_gfm_line(match, lnb)
      leading = match[1]
      columns = _split_table_columns(match.string)
      TableLine.new( content: match.string, columns: columns, is_header: _determine_if_header(columns), indent: leading.size, line: match.string, lnb: lnb)
    end

    module_function def _make_text(match, lnb)
      Text.new(
        content: match[2],
        indent: match[1].size,
        line: match.string,
        lnb: lnb)
    end

    module_function def _determine_if_header(columns)
      columns
        .all?{ |col| TableColumnRgx.match?(col) }
    end


    module_function def _split_table_columns(line)
      line
        .split(%r{(?<!\\)\|})
        .map(&:strip)
        .map{ |col| col.gsub(%r{\\\|}, "|") }
    end
  end
end
