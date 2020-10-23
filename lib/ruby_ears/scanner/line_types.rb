require "ostruct"
module RubyEars
  module Scanner
    class BaseStruct < OpenStruct
      def initialize *args
        super(*args)
        self.indent ||= 0
      end
    end

    Blank                  = Class.new BaseStruct
    BlockQuote             = Class.new BaseStruct
    Fence                  = Class.new BaseStruct
    Heading                = Class.new BaseStruct
    HtmlComment            = Class.new BaseStruct
    HtmlCloseTag           = Class.new BaseStruct
    HtmlOneLine            = Class.new BaseStruct
    HtmlOpenTag            = Class.new BaseStruct
    Ial                    = Class.new BaseStruct
    IdDef                  = Class.new BaseStruct
    Indent                 = Class.new BaseStruct
    Ruler                  = Class.new BaseStruct
    SetextUnderlineHeading = Class.new BaseStruct
    TableLine              = Class.new BaseStruct
    Text                   = Class.new BaseStruct

    class Blank < BaseStruct
      def line= _; end
      def indent= _; end
    end

    class ListItem < BaseStruct
      def initialize *args
        super(*args)
        self.initial_indent ||= 0
      end
    end
  end
end
