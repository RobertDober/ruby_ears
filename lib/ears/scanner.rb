# frozen_string_literal: true

module Ears
  module Scanner
    extend self
    include Tokens

    Bullets = [
      "\\*", "-", "\\+", "\\d+\\."
    ].join("|").freeze

    BacktixRgx = / ((?<!\\) `+) /x
    BlankRgx = /\A \s* \z/x
    HeaderRgx = /\A (\s*) (\#{1,6}) \s (.*) /x
    IndentRgx = /\A (\s{4,}) (.*) /x
    LeadingSpacesRgx = /\A (\s*) (.*) /x
    ListItemRgx = /\A (\s*) (#{Bullets}) (\s+) (.*) /x

    def scan(line, lnb)
      case line
      when BlankRgx
        Pair(Blank.new(lnb:), :eol)
      when IndentRgx
        _scan_indent(line, lnb, Regexp.last_match)
      else
        _scan_with_rest(line, lnb)
      end
    end

    private

    def _get_rest_from_pair(token)
      case token.content.split(BacktixRgx, 2)
      in [ prefix, backtix, suffix ]
        Pair(token.merge(content: prefix), backtix + suffix)
      else
        Pair(token, :eol)
      end
    end

    def _scan_indent(line, lnb, match)
      match => [_, spaces, rest]
      Pair(Indent.new(indent: spaces.length, content: rest, line:, lnb:), :eol)
    end

    def _scan_header(line, lnb, match)
      match => [_, spaces, headers, rest]
      Header.new(indent: spaces.length, content: rest, level: headers.length, line:, lnb:)
    end

    def _scan_list_item(line, lnb, match)
      match => [_, spaces, bullet, li_space, rest]
      list_indent = spaces.length + bullet.length + li_space.length
      ListItem.new(bullet:, line:, lnb:, list_indent:, indent: spaces.length, content: rest)
    end

    def _scan_text(line, lnb)
      LeadingSpacesRgx.match(line) => [_, spaces, text]
      Text.new(content: text, indent: spaces.length, line:, lnb:)
    end

    def _scan_with_rest(line, lnb)
      token = _scan_with_rest_base(line, lnb)
      _get_rest_from_pair(token)
    end

    def _scan_with_rest_base(line, lnb)
      case line
      when HeaderRgx
        _scan_header(line, lnb, Regexp.last_match)
      when ListItemRgx
        _scan_list_item(line, lnb, Regexp.last_match)
      else
        _scan_text(line, lnb)
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
