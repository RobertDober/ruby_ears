module RubyEars
  module Renderer
    Block = RubyEars::Parser::Block
    Quad  = RubyEars::Parser::Quad
   
    module_function def render(blocks, options)
      [:ok, blocks.map{|blk| _render_block(blk, options)}, []]
    end


    private

    module_function def quad(tag, content, atts: {}, meta: {})
      Quad.new(atts: atts, content: content, meta: meta, tag: tag.to_s)
    end

    module_function def _render_block(block, options)
    require "pry"; binding.pry
      case block
      when Block::Para
        quad(:para, block.lines )
      end
      
    end

  end
end
