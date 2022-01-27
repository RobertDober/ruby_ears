# frozen_string_literal: true

class Array
  def reverse_inject(acc, &blk)
    reverse_each { |ele| acc = blk.(acc, ele) }
    acc
  end
end
#  SPDX-License-Identifier: Apache-2.0
