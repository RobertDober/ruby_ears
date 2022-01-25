# frozen_string_literal: true

require 'lab42/data_class'
module RubyEars
  module Parser
    module ListParser
      State = DataClass \
        body_lines: [],
        continues_list: false,
        has_body: false,
        header_block: nil,
        header_content: nil,
        list: nil,
        list_item: nil,
        rest_to_parse: [],
        result: [],
        spaced: false do
          def reset_for_next_item
            merge(continues_list: false, has_body: false, header_block: nil, result: [], spaced: false)
          end
        end
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
