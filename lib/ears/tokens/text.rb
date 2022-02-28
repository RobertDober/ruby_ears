# frozen_string_literal: true

module Ears
  module Tokens
    class Text
      include Token
      extend DataClass

      derive :content do
        _1.line.strip
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
