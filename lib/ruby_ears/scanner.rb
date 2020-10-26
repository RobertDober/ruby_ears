require 'ostruct'
require_relative "scanner/line_types"
require_relative "scanner/makers"
module RubyEars
  module Scanner
    module_function

    BlankRgx                  = %r{\A \s* \z}x
    BlockQuoteRgx             = %r{\A (\s{0,3}) > \s? (.*) \z}x
    FenceRgx                  = %r{\A (\s*) (`{3,}|~{3,}) \s* ([^`\s]*) \s* \z}x
    HeadingRgx                = %r{\A (\#{1,6}) \s+ (.*) \z}x
    HtmlCompleteCommentRgx    = %r{\A (\s{0,3}) <! (?: -- .*? -- \s* )+ > \z}x
    HtmlIncompleteCommentRgx  = %r{\A (\s{0,3}) <!-- .*? \z}x
    HtmlCloseTagRgx           = %r{\A (\s{0,3}) <\/ ([-\w]+?) >}x
    HtmlOpenTagRgx            = %r{ \A <([-\w]+?) (?:\s.*)? >}x
    HtmlOnelineVoidTagRgx     = %r{\A < ( area | br | hr | img | wbr ) \s .*? >}x
    HtmlOnelineCompleteTagRgx = %r{\A < ([-\w]+?) (?:\s.*)? > .* </\1>}x
    HtmlOnelineSimleTagRgx    = %r{\A < ([-\w]+?) (?:\s.*)? />}x
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
    IndentRgx                 = %r{\A (\s{4}+) (\s*) (.*) \z}x
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

    def scan_lines(lines)
      # N.B. First line is artificially added empty line, hence index **is** the real line number
      lines
        .each_with_index
        .map do |line, lnb|
          type_of(line, lnb: lnb)
        end
    end

    def type_of(line, lnb: 42)
      case line
      when BlankRgx
        return Blank.new(lnb: lnb)
      when IndentRgx
        return _make_indent(Regexp.last_match, lnb)
      when FenceRgx
        return _make_fence(Regexp.last_match, lnb)
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
      when HtmlCloseTagRgx
        return _make_html_close_tag(Regexp.last_match, lnb)
      when HtmlOnelineCompleteTagRgx, HtmlOnelineSimleTagRgx,HtmlOnelineVoidTagRgx
        return _make_html_oneline_tag(Regexp.last_match, lnb)
      when HtmlOpenTagRgx
        return _make_html_open_tag(Regexp.last_match, lnb)
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
      when BlockQuoteRgx
        return _make_block_quote(Regexp.last_match, lnb)
      when BlankRgx
        return Blank.new(lnb: lnb)
      when TextRgx
        return _make_text(Regexp.last_match, lnb)
      end
      raise "Ooops no such line type #{line.inspect}"
    end


  end
end
