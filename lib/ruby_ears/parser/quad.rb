module RubyEars
  module Parser
    class Quad
      Error = Class.new RuntimeError
      attr_reader :atts, :content, :meta, :tag

      def ==(other)
        return false unless self.class === other
        other.tag == tag && other.atts == atts && other.content == content && other.meta == meta 
      end

      def to_h
        {atts: atts, content: content, meta: meta, tag: tag}
      end

      private

      def initialize(tag:, atts: {}, content: [], meta: {} )
        raise Error, "not a tag #{tag.inspect}" unless String === tag
        raise Error, "not a content list #{content.inspect}" unless Array === content
        raise Error, "not an atts map #{atts.inspect}" unless Hash === atts
        raise Error, "not an meta map #{meta.inspect}" unless Hash === meta
        @atts    = atts
        @content = content
        @meta    = meta
        @tag     = tag
      end
    end
  end
end

