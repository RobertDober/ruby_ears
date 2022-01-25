require "ostruct"
require "lab42/data_class"
module RubyEars
  module Parser
    List = DataClass \
      attrs: nil,
      blocks: [],
      lines: [],
      bullet: "-",
      indent: 0,
      lnb: 0,
      is_loose: false,
      is_spaced: false,
      start: "",
      type: :ul do
        def self.make(list_item)
          new(bullet: li.bullet, indent: li.list_indent, lnb: li.lnb, type: li.type)
        end
      end

    Para = DataClass \
      attrs: nil,
      lnb: 0,
      lines: []
  end

  class Block < OpenStruct
    Blank   = Class.new self
    Heading = Class.new self
  end
end
