# frozen_string_literal: true
module Ears
  module Tokens
    module Token
      extend DataClass
      attributes :line, indent: 0, lnb: 0, ann: nil, ial: nil
      constraint :indent, [:>=, 0]
      constraint :lnb, [:>=, 0]
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
