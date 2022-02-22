# frozen_string_literal: true

module Ears
  module Tokens
    extend self
    BaseAttributes = %i[content line].freeze
    BaseKeywords   = { indent: 0, lnb: 0, ann: nil, ial: nil }.freeze

    def token(*a, **k)
      DataClass(*(a + BaseAttributes), **BaseKeywords.merge(k))
    end
  end
end
