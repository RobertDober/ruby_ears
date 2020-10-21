require "ruby_ears/scanner"
RSpec.describe RubyEars::Scanner do
  Scanner = RubyEars::Scanner

  let(:id1) { %{[ID1]: http://example.com  "The title"} }
  let(:id2) { %{[ID2]: http://example.com  'The title'} }
  let(:id3) { %{[ID3]: http://example.com  (The title)} }
  let(:id4) { %{[ID4]: http://example.com} }
  let(:id5) { %{[ID5]: <http://example.com>  "The title"} }
  let(:id6) { %{ [ID6]: http://example.com  "The title"} }
  let(:id7) { %{  [ID7]: http://example.com  "The title"} }
  let(:id8) { %{   [ID8]: http://example.com  "The title"} }
  let(:id9) { %{    [ID9]: http://example.com  "The title"} }
  let(:id10) { %{[ID10]: /url/ "Title with "quotes" inside"} }
  let(:id11) { %{[ID11]: http://example.com "Title with trailing whitespace" } }


  context Scanner::Blank do
    # { "        ", RubyEars::Scanner::Blank{} },
    it{ expect(Scanner.type_of("")).to eq(Scanner::Blank.new(lnb: 42)) } 
    it{ expect(Scanner.type_of("    ")).to eq(Scanner::Blank.new(lnb: 42)) } 
  end

  context Scanner::HtmlComment do
    # { "<!-- comment -->", RubyEars::Scanner::HtmlComment{complete: true} },
    it "complete comment" do
      expected = Scanner::HtmlComment.new(
        complete: true,
        indent: 2,
        line: "  <!-- hello -->",
        lnb: 42
      )
      expect(Scanner.type_of("  <!-- hello -->")).to eq(expected)
    end

    # { "<!-- comment",     RubyEars::Scanner::HtmlComment{complete: false} },
    it "incomplete comment" do
      expected = Scanner::HtmlComment.new(
        complete: false,
        indent: 0,
        line: "<!-- comment",
        lnb: 42
      )
      expect(Scanner.type_of("<!-- comment")).to eq(expected)
    end
  end

  context Scanner::ListItem do
    it "- bullet" do
      expected = Scanner::ListItem.new(
        bullet: "-",
        content: "-",
        indent: 0,
        initial_indent: 0,
        line: "- -",
        list_indent: 2,
        lnb: 42,
        type: :ul
      )
      expect(Scanner.type_of("- -")).to eq(expected)
    end

    it "* bullet" do
      expected = Scanner::ListItem.new(
        bullet: "*",
        content: "*",
        indent: 0,
        initial_indent: 0,
        line: "* *",
        list_indent: 2,
        lnb: 42,
        type: :ul
      )

      expect(Scanner.type_of("* *")).to eq(expected)

    end


  end

  # { "- - -", RubyEars::Scanner::Ruler{type: "-"} },
  # { "--",    RubyEars::Scanner::SetextUnderlineHeading{level: 2} },
  # { "---",   RubyEars::Scanner::Ruler{type: "-"} },

  # { "* *",   RubyEars::Scanner::ListItem{type: :ul, bullet: "*", content: "*", list_indent: 2} },
  # { "* * *", RubyEars::Scanner::Ruler{type: "*"} },
  # { "**",    RubyEars::Scanner::Text{content: "**"} },
  # { "***",   RubyEars::Scanner::Ruler{type: "*"} },

  # { "_ _",   RubyEars::Scanner::Text{content: "_ _"} },
  # { "_ _ _", RubyEars::Scanner::Ruler{type: "_"} },
  # { "__",    RubyEars::Scanner::Text{content: "__"} },
  # { "___",   RubyEars::Scanner::Ruler{type: "_"} },

  # { "# H1",       RubyEars::Scanner::Heading{level: 1, content: "H1"} },
  # { "## H2",      RubyEars::Scanner::Heading{level: 2, content: "H2"} },
  # { "### H3",     RubyEars::Scanner::Heading{level: 3, content: "H3"} },
  # { "#### H4",    RubyEars::Scanner::Heading{level: 4, content: "H4"} },
  # { "##### H5",   RubyEars::Scanner::Heading{level: 5, content: "H5"} },
  # { "###### H6",  RubyEars::Scanner::Heading{level: 6, content: "H6"} },
  # { "####### H7", RubyEars::Scanner::Text{content: "####### H7"} },

  # { "> quote",    RubyEars::Scanner::BlockQuote{content: "quote"} },
  # { ">    quote", RubyEars::Scanner::BlockQuote{content: "   quote"} },
  # { ">quote",     RubyEars::Scanner::BlockQuote{content: "quote"} },

  # #1234567890123
  # { "   a",         RubyEars::Scanner::Text{content: "   a"} },
  # { "    b",        RubyEars::Scanner::Indent{level: 1, content: "b"} },
  # { "      c",      RubyEars::Scanner::Indent{level: 1, content: "  c"} },
  # { "        d",    RubyEars::Scanner::Indent{level: 2, content: "d"} },
  # { "          e",  RubyEars::Scanner::Indent{level: 2, content: "  e"} },
  # { "    - f",      RubyEars::Scanner::Indent{bullet: "-", level: 1, content: "- f"} },
  # { "     *  g",    RubyEars::Scanner::Indent{bullet: "*", level: 1, content: " *  g"} },
  # { "      012) h", RubyEars::Scanner::Indent{bullet: "012)", level: 1, content: "  012) h"} },

  # { "```",      RubyEars::Scanner::Fence{delimiter: "```", language: "",     line: "```"} },
  # { "``` java", RubyEars::Scanner::Fence{delimiter: "```", language: "java", line: "``` java"} },
  # { " ``` java", RubyEars::Scanner::Fence{delimiter: "```", language: "java", line: " ``` java"} },
  # { "```java",  RubyEars::Scanner::Fence{delimiter: "```", language: "java", line: "```java"} },
  # { "```language-java",  RubyEars::Scanner::Fence{delimiter: "```", language: "language-java"} },
  # { "```language-élixir",  RubyEars::Scanner::Fence{delimiter: "```", language: "language-élixir"} },
  # { "   `````",  RubyEars::Scanner::Fence{delimiter: "`````", language: "", line: "   `````"} },

  # { "~~~",      RubyEars::Scanner::Fence{delimiter: "~~~", language: "",     line: "~~~"} },
  # { "~~~ java", RubyEars::Scanner::Fence{delimiter: "~~~", language: "java", line: "~~~ java"} },
  # { "  ~~~java",  RubyEars::Scanner::Fence{delimiter: "~~~", language: "java", line: "  ~~~java"} },
  # { "~~~ language-java", RubyEars::Scanner::Fence{delimiter: "~~~", language: "language-java"} },
  # { "~~~ language-élixir",  RubyEars::Scanner::Fence{delimiter: "~~~", language: "language-élixir"} },
  # { "~~~~ language-élixir",  RubyEars::Scanner::Fence{delimiter: "~~~~", language: "language-élixir"} },

  # { "``` hello ```", RubyEars::Scanner::Text{content: "``` hello ```"} },
  # { "```hello```", RubyEars::Scanner::Text{content: "```hello```"} },
  # { "```hello world", RubyEars::Scanner::Text{content: "```hello world"} },

  # { "<pre>",             RubyEars::Scanner::HtmlOpenTag{tag: "pre", content: "<pre>"} },
  # { "<pre class='123'>", RubyEars::Scanner::HtmlOpenTag{tag: "pre", content: "<pre class='123'>"} },
  # { "</pre>",            RubyEars::Scanner::HtmlCloseTag{tag: "pre"} },
  # { "   </pre>",            RubyEars::Scanner::HtmlCloseTag{indent: 3, tag: "pre"} },

  # { "<pre>a</pre>",      RubyEars::Scanner::HtmlOneLine{tag: "pre", content: "<pre>a</pre>"} },

  # { "<area>",              RubyEars::Scanner::HtmlOneLine{tag: "area", content: "<area>"} },
  # { "<area/>",             RubyEars::Scanner::HtmlOneLine{tag: "area", content: "<area/>"} },
  # { "<area class='a'>",    RubyEars::Scanner::HtmlOneLine{tag: "area", content: "<area class='a'>"} },

  # { "<br>",              RubyEars::Scanner::HtmlOneLine{tag: "br", content: "<br>"} },
  # { "<br/>",             RubyEars::Scanner::HtmlOneLine{tag: "br", content: "<br/>"} },
  # { "<br class='a'>",    RubyEars::Scanner::HtmlOneLine{tag: "br", content: "<br class='a'>"} },

  # { "<hr />",              RubyEars::Scanner::HtmlOneLine{tag: "hr", content: "<hr />"} },
  # { "<hr/>",             RubyEars::Scanner::HtmlOneLine{tag: "hr", content: "<hr/>"} },
  # { "<hr class='a'>",    RubyEars::Scanner::HtmlOneLine{tag: "hr", content: "<hr class='a'>"} },

  # { "<img>",              RubyEars::Scanner::HtmlOneLine{tag: "img", content: "<img>"} },
  # { "<img/>",             RubyEars::Scanner::HtmlOneLine{tag: "img", content: "<img/>"} },
  # { "<img class='a'>",    RubyEars::Scanner::HtmlOneLine{tag: "img", content: "<img class='a'>"} },

  # { "<wbr>",              RubyEars::Scanner::HtmlOneLine{tag: "wbr", content: "<wbr>"} },
  # { "<wbr/>",             RubyEars::Scanner::HtmlOneLine{tag: "wbr", content: "<wbr/>"} },
  # { "<wbr class='a'>",    RubyEars::Scanner::HtmlOneLine{tag: "wbr", content: "<wbr class='a'>"} },

  # { "<h2>Headline</h2>",               RubyEars::Scanner::HtmlOneLine{tag: "h2", content: "<h2>Headline</h2>"} },
  # { "<h2 id='headline'>Headline</h2>", RubyEars::Scanner::HtmlOneLine{tag: "h2", content: "<h2 id='headline'>Headline</h2>"} },

  # { "<h3>Headline",               RubyEars::Scanner::HtmlOpenTag{tag: "h3", content: "<h3>Headline"} },

  # { id1, RubyEars::Scanner::IdDef{id: "ID1", url: "http://example.com", title: "The title"} },
  # { id2, RubyEars::Scanner::IdDef{id: "ID2", url: "http://example.com", title: "The title"} },
  # { id3, RubyEars::Scanner::IdDef{id: "ID3", url: "http://example.com", title: "The title"} },
  # { id4, RubyEars::Scanner::IdDef{id: "ID4", url: "http://example.com", title: ""} },
  # { id5, RubyEars::Scanner::IdDef{id: "ID5", url: "http://example.com", title: "The title"} },
  # { id6, RubyEars::Scanner::IdDef{id: "ID6", url: "http://example.com", title: "The title"} },
  # { id7, RubyEars::Scanner::IdDef{id: "ID7", url: "http://example.com", title: "The title"} },
  # { id8, RubyEars::Scanner::IdDef{id: "ID8", url: "http://example.com", title: "The title"} },
  # { id9, RubyEars::Scanner::Indent{content: "[ID9]: http://example.com  \"The title\"",
  #     level: 1,       line: "    [ID9]: http://example.com  \"The title\""} },

  #   {id10, RubyEars::Scanner::IdDef{id: "ID10", url: "/url/", title: "Title with \"quotes\" inside"}},
  #   {id11, RubyEars::Scanner::IdDef{id: "ID11", url: "http://example.com", title: "Title with trailing whitespace"}},


  #   { "* ul1", RubyEars::Scanner::ListItem{ type: :ul, bullet: "*", content: "ul1", list_indent: 2} },
  #   { "+ ul2", RubyEars::Scanner::ListItem{ type: :ul, bullet: "+", content: "ul2", list_indent: 2} },
  #   { "- ul3", RubyEars::Scanner::ListItem{ type: :ul, bullet: "-", content: "ul3", list_indent: 2} },

  #   { "*     ul4", RubyEars::Scanner::ListItem{ type: :ul, bullet: "*", content: "    ul4", list_indent: 6} },
  #   { "*ul5",      RubyEars::Scanner::Text{content: "*ul5"} },

  #   { "1. ol1",          RubyEars::Scanner::ListItem{ type: :ol, bullet: "1.", content: "ol1", list_indent: 3} },
  #   { "12345.      ol2", RubyEars::Scanner::ListItem{ type: :ol, bullet: "12345.", content: "     ol2", list_indent: 7} },
  #   { "12345)      ol3", RubyEars::Scanner::ListItem{ type: :ol, bullet: "12345)", content: "     ol3", list_indent: 7} },

  #   { "1234567890. ol4", RubyEars::Scanner::Text{ content: "1234567890. ol4"} },
  #   { "1.ol5", RubyEars::Scanner::Text{ content: "1.ol5"} },

  #   { "=",        RubyEars::Scanner::SetextUnderlineHeading{level: 1} },
  #   { "========", RubyEars::Scanner::SetextUnderlineHeading{level: 1} },
  #   { "-",        RubyEars::Scanner::SetextUnderlineHeading{level: 2} },
  #   { "= and so", RubyEars::Scanner::Text{content: "= and so"} },

  #   { "   (title)", RubyEars::Scanner::Text{content: "   (title)"} },

  #   { "{: .attr }",       RubyEars::Scanner::Ial{attrs: ".attr", verbatim: " .attr "} },
  #   { "{:.a1 .a2}",       RubyEars::Scanner::Ial{attrs: ".a1 .a2", verbatim: ".a1 .a2"} },

  #   { "  | a | b | c | ", RubyEars::Scanner::TableLine{content: "  | a | b | c | ",
  #       columns: ~w{a b c} } },
  #   { "  | a         | ", RubyEars::Scanner::TableLine{content: "  | a         | ",
  #       columns: ~w{a} } },
  #   { "  a | b | c  ",    RubyEars::Scanner::TableLine{content: "  a | b | c  ",
  #       columns: ~w{a b c} } },
  #   { "  a \\| b | c  ",  RubyEars::Scanner::TableLine{content: "  a \\| b | c  ",
  #       columns: [ "a | b",  "c"] } },

  #   #
  #   # Footnote Definitions but no footnote option
  #   #
  #   { "[^1]: bar baz", %EarmarkParser.Line.Text{content: "[^1]: bar baz", inside_code: false,
  #                    line: "[^1]: bar baz", lnb: 42}},

end

# SPDX-License-Identifier: Apache-2.0
