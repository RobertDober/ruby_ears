require "ruby_ears/parser"
module AstSupport

  def tag(tag, *content)
    {tag: tag, content: content}
  end

  %i[li p ul]
    .each do |tag_|
      define_method tag_ do |*content|
        tag(tag_, *content)
      end
    end

  private

  def _parse(lines)
    RubyEars::Parser.parse(lines)
  end
end

RSpec.configure do |conf|
  conf.include AstSupport, type: :parser
end
#  SPDX-License-Identifier: Apache-2.0
