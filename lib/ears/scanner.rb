# frozen_string_literal: true

module Ears
  module Scanner
    extend self
    include Tokens

    BacktixRgx = / ((?<!\\) `+) /x
    BlankRgx = /\A \s* \z/x
    HeaderRgx = /\A (\s*) (\#{1,6}) \s (.*) /x
    IndentRgx = /\A (\s{4,}) (.*) /x
    LeadingSpacesRgx = /\A (\s*) (.*) /x

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

    def _get_rest_from_pair(pair)
      pair => [token, :eol]
      case token.line.split(BacktixRgx, 2)
      in [ prefix, backtix, suffix ]
        Pair(token.merge(content: prefix), backtix + suffix)
      else
        pair
      end
    end

    def _scan_indent(line, lnb, match)
      match => [_, spaces, rest]
      Pair(Indent.new(indent: spaces.length, content: rest, line:, lnb:), :eol)
    end

    def _scan_header(line, lnb, match)
      match => [_, spaces, headers, rest]
      Pair(Header.new(indent: spaces.length, content: rest, level: headers.length, line:, lnb:), :eol)
    end

    def _scan_text(line, lnb)
      LeadingSpacesRgx.match(line) => [_, spaces, text]
      Pair(Text.new(content: text, indent: spaces.length, line:, lnb:), :eol)
    end

    def _scan_with_rest(line, lnb)
      pair =
        case line
        when HeaderRgx
          _scan_header(line, lnb, Regexp.last_match)
        else
          _scan_text(line, lnb)
        end
      _get_rest_from_pair(pair)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
