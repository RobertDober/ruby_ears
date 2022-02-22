# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

require "lab42/data_class"

class MatchData
  def deconstruct
    to_a
  end
end

module Ears
  extend self
end
# SPDX-License-Identifier: Apache-2.0
