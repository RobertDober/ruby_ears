# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

require "lab42/data_class"
# require_relative "../../../lab42/lab42_data_class/lib/lab42/data_class"
include Lab42

class MatchData
  def deconstruct
    to_a
  end
end

module Ears
end
# SPDX-License-Identifier: Apache-2.0
