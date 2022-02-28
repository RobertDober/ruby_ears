# frozen_string_literal: true

module Ears
  module Tokens
    class Blank < DataClass(lnb: 0, ann: nil, ial: nil)
      Rgx = /\A \s* \z/x
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
