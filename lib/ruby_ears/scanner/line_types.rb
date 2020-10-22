require "ostruct"
module RubyEars
  module Scanner
    Blank                  = Class.new OpenStruct
    BlockQuote             = Class.new OpenStruct
    Fence                  = Class.new OpenStruct
    Heading                = Class.new OpenStruct
    HtmlComment            = Class.new OpenStruct
    HtmlCloseTag           = Class.new OpenStruct
    HtmlOneLine            = Class.new OpenStruct
    HtmlOpenTag            = Class.new OpenStruct
    Ial                    = Class.new OpenStruct
    IdDef                  = Class.new OpenStruct
    Indent                 = Class.new OpenStruct
    Ruler                  = Class.new OpenStruct
    SetextUnderlineHeading = Class.new OpenStruct
    TableLine              = Class.new OpenStruct
    Text                   = Class.new OpenStruct

    class Blank < OpenStruct
      def line= _; end
      def indent= _; end
    end

    class ListItem < OpenStruct
      def initialize *args
        super(*args)
        self.initial_indent ||= 0
      end
    end
  end
end
