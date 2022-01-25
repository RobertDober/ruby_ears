require 'lab42/data_class'
module RubyEars

  module Scanner extend self

    def base_factory(*a, **k)
      k_ = {
        content: "",
        indent: 0,
        line: "",
        lnb: 0
      }.merge(k)
      DataClass(*a, **k_)
    end

    Blank                  = base_factory
    BlockQuote             = base_factory
    Fence                  = base_factory delimiter: "```", language: ""
    Heading                = base_factory :level
    HtmlComment            = base_factory lnb: 0, complete: false
    HtmlCloseTag           = base_factory :tag
    HtmlOneLine            = base_factory :tag
    HtmlOpenTag            = base_factory :tag
    Ial                    = base_factory :attrs, :verbatim
    IdDef                  = base_factory :id, :url, title: ""
    Indent                 = base_factory :level
    ListItem               = base_factory :list_indent, bullet: '-', type: :ul
    Ruler                  = base_factory :type
    SetextUnderlineHeading = base_factory :level
    TableLine              = base_factory columns: [], is_header: false
    Text                   = base_factory

  end
end
