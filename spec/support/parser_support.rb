module ParserSupport
  def quad(tag, content, atts: {}, meta: {})
    content = [content] if content.is_a?(String)
    RubyEars::Parser::Quad.new(tag:, content:, atts:, meta:)
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
    lines = lines.split("\n") if lines.is_a?(String)
    lines = RubyEars::Scanner.scan_lines(lines)
    blocks, = RubyEars::Parser.lines_to_blocks(lines)
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
