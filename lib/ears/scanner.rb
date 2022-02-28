# frozen_string_literal: true

module Ears
  module Scanner
    extend self
    include Tokens

    BacktixRgx = / ((?<!\\) `+) /x

    def scan(line, lnb)
      token = _scan_for_tokens_wo_backtix(line, lnb)
      if token
        Pair(token, :eol)
      else
        _make_pair(_scan_for_tokens_with_backtix(line, lnb))
      end
    end

    private

    def _make_pair(token)
      case token.content.split(BacktixRgx, 2)
      in [ prefix, backtix, suffix ]
        Pair(token.merge(content: prefix), backtix + suffix)
      else
        Pair(token, :eol)
      end
    end

    def _scan_for_tokens_with_backtix(line, lnb)
      case line
      when Header::Rgx
        Header.make(line, lnb, Regexp.last_match)
      when ListItem::Rgx
        ListItem.make(line, lnb, Regexp.last_match)
      else
        Text.make(line, lnb)
      end
    end

    def _scan_for_tokens_wo_backtix(line, lnb)
      case line
      when Blank::Rgx
        Blank.new(lnb:)
      when Indent::Rgx
        Indent.make(line, lnb, Regexp.last_match)
      when ThematicBreak::Rgx
        ThematicBreak.make(line, lnb, Regexp.last_match)
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
