require "ostruct"
module RubyEars
  module Parser
    class Block < OpenStruct
      Blank = Class.new self
      Para  = Class.new self
      Text  = Class.new self
    end


  end
end
