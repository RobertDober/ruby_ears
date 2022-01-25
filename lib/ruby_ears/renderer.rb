module RubyEars
  module Renderer extend self
    Block = RubyEars::Parser::Block
    Quad  = RubyEars::Parser::Quad

    def render(blocks, options)
      ast = blocks.map{|blk| _render_block(blk, options)}
      [:ok, ast, []]
    end


    private

    def quad(tag, content, atts: {}, meta: {})
      Quad.new(atts: atts, content: content, meta: meta, tag: tag.to_s)
    end

    def _render_block(block, options)
      case block
      when Block::Para
        quad(:p, block.lines )
      else
        raise NotImplementedError, "unknown block #{block.inspect}"
      end
    end

  end
end
