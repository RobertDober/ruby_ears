require "ruby_ears/scanner"
RSpec.describe RubyEars::Scanner do
  Scanner = RubyEars::Scanner

  id1 = %{[ID1]: http://example.com  "The title"}
  id2 = %{[ID2]: http://example.com  'The title'}
  id3 = %{[ID3]: http://example.com  (The title)}
  id4 = %{[ID4]: http://example.com}
  id5 = %{[ID5]: <http://example.com>  "The title"}
  id6 = %{ [ID6]: http://example.com  "The title"}
  id7 = %{  [ID7]: http://example.com  "The title"}
  id8 = %{   [ID8]: http://example.com  "The title"}
  id9 = %{    [ID9]: http://example.com  "The title"}
  id10 = %{[ID10]: /url/ "Title with "quotes" inside"}
  id11 = %{[ID11]: http://example.com "Title with trailing whitespace" }
  id12 = %{[ID12]: ]hello }

  [
    [ "",         Scanner::Blank.new() ],
    [ "        ", Scanner::Blank.new() ],

    [ "<!-- comment -->", Scanner::HtmlComment.new(complete: true) ],
    [ "<!-- comment",     Scanner::HtmlComment.new(complete: false) ],

    [ "- -",   Scanner::ListItem.new(type: :ul, bullet: "-", content: "-", list_indent: 2) ],
    [ "- - -", Scanner::Ruler.new(type: "-") ],

    [ "--",    Scanner::SetextUnderlineHeading.new(level: 2) ],
    [ "---",   Scanner::Ruler.new(type: "-") ],

    [ "* *",   Scanner::ListItem.new(type: :ul, bullet: "*", content: "*", list_indent: 2) ],
    [ "* * *", Scanner::Ruler.new(type: "*") ],
    [ "**",    Scanner::Text.new(content: "**", line: "**") ],
    [ "***",   Scanner::Ruler.new(type: "*") ],

    [ "_ _",   Scanner::Text.new(content: "_ _") ],
    [ "_ _ _", Scanner::Ruler.new(type: "_") ],
    [ "__",    Scanner::Text.new(content: "__") ],
    [ "___",   Scanner::Ruler.new(type: "_") ],

    [ "# H1",       Scanner::Heading.new(level: 1, content: "H1") ],
    [ "## H2",      Scanner::Heading.new(level: 2, content: "H2") ],
    [ "### H3",     Scanner::Heading.new(level: 3, content: "H3") ],
    [ "#### H4",    Scanner::Heading.new(level: 4, content: "H4") ],
    [ "##### H5",   Scanner::Heading.new(level: 5, content: "H5") ],
    [ "###### H6",  Scanner::Heading.new(level: 6, content: "H6") ],
    [ "####### H7", Scanner::Text.new(content: "####### H7") ],

    [ "> quote0",    Scanner::BlockQuote.new(content: "quote0") ],
    [ ">    quote1", Scanner::BlockQuote.new(content: "   quote1") ],
    [ ">quote2",     Scanner::BlockQuote.new(content: "quote2") ],
    [ " >  quote3",     Scanner::BlockQuote.new(content: " quote3", indent: 1) ],

    #1234567890123
    [ "   a",         Scanner::Text.new(indent: 3,content: "a", line: "   a") ],
    [ "    b",        Scanner::Indent.new(indent: 4, level: 1, content: "b") ],
    [ "      c",      Scanner::Indent.new(indent: 6, level: 1, content: "  c") ],
    [ "        d",    Scanner::Indent.new(indent: 8, level: 2, content: "d") ],
    [ "          e",  Scanner::Indent.new(indent: 10, level: 2, content: "  e") ],
    [ "    - f",      Scanner::Indent.new(indent: 4, level: 1, content: "- f") ],
    [ "     *  g",    Scanner::Indent.new(indent: 5, level: 1, content: " *  g") ],
    [ "      012) h", Scanner::Indent.new(indent: 6, level: 1, content: "  012) h") ],

    [ "```",      Scanner::Fence.new(delimiter: "```", language: "",     line: "```") ],
    [ "``` java", Scanner::Fence.new(delimiter: "```", language: "java", line: "``` java") ],
    [ " ``` java", Scanner::Fence.new(delimiter: "```", indent: 1, language: "java", line: " ``` java") ],
    [ "```java",  Scanner::Fence.new(delimiter: "```", language: "java", line: "```java") ],
    [ "```language-java",  Scanner::Fence.new(delimiter: "```", language: "language-java") ],
    [ "```language-élixir",  Scanner::Fence.new(delimiter: "```", language: "language-élixir") ],
    [ "   `````",  Scanner::Fence.new(delimiter: "`````", indent: 3, language: "", line: "   `````") ],

    [ "~~~",      Scanner::Fence.new(delimiter: "~~~", language: "",     line: "~~~") ],
    [ "~~~ java", Scanner::Fence.new(delimiter: "~~~", language: "java", line: "~~~ java") ],
    [ "  ~~~java",  Scanner::Fence.new(delimiter: "~~~", indent: 2, language: "java", line: "  ~~~java") ],
    [ "~~~ language-java", Scanner::Fence.new(delimiter: "~~~", language: "language-java") ],
    [ "~~~ language-élixir",  Scanner::Fence.new(delimiter: "~~~", language: "language-élixir") ],
    [ "~~~~ language-élixir",  Scanner::Fence.new(delimiter: "~~~~", language: "language-élixir") ],

    [ "``` hello ```", Scanner::Text.new(content: "``` hello ```") ],
    [ "```hello```", Scanner::Text.new(content: "```hello```") ],
    [ "```hello world", Scanner::Text.new(content: "```hello world") ],

    [ "<pre>",             Scanner::HtmlOpenTag.new(tag: "pre", content: "<pre>") ],
    [ "<pre class='123'>", Scanner::HtmlOpenTag.new(tag: "pre", content: "<pre class='123'>") ],
    [ "</pre>",            Scanner::HtmlCloseTag.new(tag: "pre") ],
    [ "   </pre>",            Scanner::HtmlCloseTag.new(indent: 3, tag: "pre") ],

    [ "<pre>a</pre>",      Scanner::HtmlOneLine.new(tag: "pre", content: "<pre>a</pre>") ],

    [ "<area>",              Scanner::HtmlOneLine.new(tag: "area", content: "<area>") ],
    [ "<area/>",             Scanner::HtmlOneLine.new(tag: "area", content: "<area/>") ],
    [ "<area class='a'>",    Scanner::HtmlOneLine.new(tag: "area", content: "<area class='a'>") ],

    [ "<br>",              Scanner::HtmlOneLine.new(tag: "br", content: "<br>") ],
    [ "<br/>",             Scanner::HtmlOneLine.new(tag: "br", content: "<br/>") ],
    [ "<br class='a'>",    Scanner::HtmlOneLine.new(tag: "br", content: "<br class='a'>") ],

    [ "<hr />",              Scanner::HtmlOneLine.new(tag: "hr", content: "<hr />") ],
    [ "<hr/>",             Scanner::HtmlOneLine.new(tag: "hr", content: "<hr/>") ],
    [ "<hr class='a'>",    Scanner::HtmlOneLine.new(tag: "hr", content: "<hr class='a'>") ],

    [ "<img>",              Scanner::HtmlOneLine.new(tag: "img", content: "<img>") ],
    [ "<img/>",             Scanner::HtmlOneLine.new(tag: "img", content: "<img/>") ],
    [ "<img class='a'>",    Scanner::HtmlOneLine.new(tag: "img", content: "<img class='a'>") ],

    [ "<wbr>",              Scanner::HtmlOneLine.new(tag: "wbr", content: "<wbr>") ],
    [ "<wbr/>",             Scanner::HtmlOneLine.new(tag: "wbr", content: "<wbr/>") ],
    [ "<wbr class='a'>",    Scanner::HtmlOneLine.new(tag: "wbr", content: "<wbr class='a'>") ],

    [ "<h2>Headline</h2>",               Scanner::HtmlOneLine.new(tag: "h2", content: "<h2>Headline</h2>") ],
    [ "<h2 id='headline'>Headline</h2>", Scanner::HtmlOneLine.new(tag: "h2", content: "<h2 id='headline'>Headline</h2>") ],

    [ "<h3>Headline",               Scanner::HtmlOpenTag.new(tag: "h3", content: "<h3>Headline") ],

    [ id1, Scanner::IdDef.new(id: "ID1", url: "http://example.com", title: "The title") ],
    [ id2, Scanner::IdDef.new(id: "ID2", url: "http://example.com", title: "The title") ],
    [ id3, Scanner::IdDef.new(id: "ID3", url: "http://example.com", title: "The title") ],
    [ id4, Scanner::IdDef.new(id: "ID4", url: "http://example.com", title: "") ],
    [ id5, Scanner::IdDef.new(id: "ID5", url: "http://example.com", title: "The title") ],
    [ id6, Scanner::IdDef.new(id: "ID6", indent: 1, url: "http://example.com", title: "The title") ],
    [ id7, Scanner::IdDef.new(id: "ID7", indent: 2, url: "http://example.com", title: "The title") ],
    [ id8, Scanner::IdDef.new(id: "ID8", indent: 3, url: "http://example.com", title: "The title") ],
    [ id9, Scanner::Indent.new(content: "[ID9]: http://example.com  \"The title\"",
                        level: 1, indent: 4, line: "    [ID9]: http://example.com  \"The title\"") ],

      [ id10, Scanner::IdDef.new(id: "ID10", url: "/url/", title: "Title with \"quotes\" inside") ],
      [ id11, Scanner::IdDef.new(id: "ID11", url: "http://example.com", title: "Title with trailing whitespace") ],
      [ id12, Scanner::IdDef.new(id: "ID12", url: "]hello", title: "") ],


      [ "* ul1", Scanner::ListItem.new( type: :ul, bullet: "*", content: "ul1", list_indent: 2) ],
      [ "+ ul2", Scanner::ListItem.new( type: :ul, bullet: "+", content: "ul2", list_indent: 2) ],
      [ "- ul3", Scanner::ListItem.new( type: :ul, bullet: "-", content: "ul3", list_indent: 2) ],

      [ "*     ul4", Scanner::ListItem.new( type: :ul, bullet: "*", content: "    ul4", list_indent: 6) ],
      [ "*ul5",      Scanner::Text.new(content: "*ul5") ],

      [ "1. ol1",          Scanner::ListItem.new( type: :ol, bullet: "1.", content: "ol1", list_indent: 3) ],
      [ "12345.      ol2", Scanner::ListItem.new( type: :ol, bullet: "12345.", content: "     ol2", list_indent: 7) ],
      [ "12345)      ol3", Scanner::ListItem.new( type: :ol, bullet: "12345)", content: "     ol3", list_indent: 7) ],

      [ "1234567890. ol4", Scanner::Text.new( content: "1234567890. ol4") ],
      [ "1.ol5", Scanner::Text.new( content: "1.ol5") ],

      [ "=",        Scanner::SetextUnderlineHeading.new(level: 1) ],
      [ "========", Scanner::SetextUnderlineHeading.new(level: 1) ],
      [ "-",        Scanner::SetextUnderlineHeading.new(level: 2) ],
      [ "= and so", Scanner::Text.new(content: "= and so") ],

      [ "   (title)", Scanner::Text.new(content: "(title)", indent: 3, line: "   (title)") ],

      [ "{: .attr }",       Scanner::Ial.new(attrs: ".attr", verbatim: " .attr ") ],
      [ "{:.a1 .a2}",       Scanner::Ial.new(attrs: ".a1 .a2", verbatim: ".a1 .a2") ],

      [ "  | a | b | c | ", Scanner::TableLine.new(content: "  | a | b | c | ",
                                            columns: %w{a b c}, indent: 2, is_header: false) ],
  [ "  | a         | ", Scanner::TableLine.new(content: "  | a         | ",
                                        columns: %w{a}, indent: 2, is_header: false) ],
  [ "  a | b | c  ",    Scanner::TableLine.new(content: "  a | b | c  ",
                                        columns: %w{a b c}, is_header: false, indent: 2) ],
  [ "  a \\| b | c  ",  Scanner::TableLine.new(content: "  a \\| b | c  ",
                                              columns: [ "a | b",  "c"] ,
                                              indent: 2, is_header: false) ],

      #
      # Footnote Definitions but no footnote option
      #
  [ "[^1]: bar baz", Scanner::Text.new(content: "[^1]: bar baz",
                                              line: "[^1]: bar baz", lnb: 42) ],
  ].each_with_index do |(input, expected), idx|
    it "Example: #{idx.succ}, transforms #{input.inspect} into #{expected}" do
      lnb, input = case input
          when String
             [42, input]
          else
            input
          end
      expected_ = expected.to_h.merge(lnb: lnb, line: input, indent: expected.indent || 0)
      expect(Scanner.type_of(input,lnb: lnb).to_h).to eq(expected_)
    end
  end

end
# SPDX-License-Identifier: Apache-2.0
