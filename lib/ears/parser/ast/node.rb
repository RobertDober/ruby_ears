# frozen_string_literal: true

require "lab42/data_class/builtin_constraints"

module Ears
  module Parser
    module Ast
      class Node
        extend DataClass

        content_constraint = Choice(self, String)
        keyword_list = ListOf(Pair(String, String))

        attributes :tag, atts: Nil, content: Nil , meta: Nil

        constraint :content, ListOf(content_constraint)
        constraint :tag, Symbol
        constraint :atts, keyword_list
        constraint :meta, keyword_list

      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
