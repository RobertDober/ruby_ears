require "ruby_ears/parser"
module ParserSupport

  def quad(tag, content, atts: {}, meta: {})
    content = [content] if String === content
    RubyEars::Parser::Quad.new(tag: tag, content: content, atts: atts, meta: meta)
  end

  def parse_ok(lines)
    status, ast, messages = parse(lines)
    expect(status).to eq(:ok)
    expect(messages).to be_empty
    ast
  end

  def parse(lines)
    case lines
    when String
      _parse(lines.split("\n"))
    else
      _parse(lines)
    end
  end

  def to_blocks(lines)
    lines = lines.split("\n") if String === lines
    lines = RubyEars::Scanner.scan_lines(lines)
    blocks, _, _ = RubyEars::Parser.lines_to_blocks(lines)
    blocks
  end

  private

  def _parse(lines)
    RubyEars::Parser.parse(lines)
  end
end

RSpec.configure do |conf|
  conf.include ParserSupport, type: :parser
end
#  SPDX-License-Identifier: Apache-2.0
