# frozen_string_literal: true

module Ears
  module Tokens
    class Blank
      include Token
      extend Lab42::DataClass

      Rgx = /\A \s* \z/x

      derive(:content) { "" }
      derive(:indent) { 0 }
      derive(:line) { "" }
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
