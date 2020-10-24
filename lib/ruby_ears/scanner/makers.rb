module RubyEars
  module Scanner

    private

    module_function def _attribute_escape(string)
      string
        .gsub("&", "&amp;")
        .gsub("<", "&lt;")
    end

    module_function def _compute_list_indent(match)
      sl = match[3].size
      match[1].size + match[2].size + (sl > 4 ? 1 : sl)
    end

    module_function def _make_block_quote(match, lnb)
      BlockQuote.new(
        content: match[2],
        indent: match[1].size,
        line: match.string,
        lnb: lnb)
    end

    module_function def _make_fence(match, lnb)
      leading, fence, language = match.captures
      Fence.new(
        delimiter: fence,
        language: _attribute_escape(language),
        indent: leading.size,
        line: match.string,
        lnb: lnb)
    end

    module_function def _make_heading(match, lnb)
      Heading.new(
        content: match[2],
        level: match[1].size,
        line: match.string,
        lnb: lnb)
    end

    module_function def _make_html_close_tag(match, lnb)
      leading_spaces, tag = match.captures
      HtmlCloseTag.new(tag: tag, indent: leading_spaces.size, line: match.string, lnb: lnb)
    end

    module_function def _make_html_oneline_tag(match, lnb)
      HtmlOneLine.new(
        content: match.string,
        line: match.string,
        lnb: lnb,
        tag: match[1])
    end

    module_function def _make_html_open_tag(match, lnb)
      HtmlOpenTag.new(tag: match[1], content: match.string, indent: 0, line: match.string, lnb: lnb)
    end

    module_function def _make_ial(match, lnb)
      # %r<\A (\s{0,3}) {:(\s*[^}]+)} \s \z>x
      leading, ial = match.captures
      Ial.new(attrs: ial.strip, indent: leading.size, lnb: lnb, line: match.string, verbatim: ial)
    end

    module_function def _make_id_ref(match, lnb)
      leading, id, url, title = match.named_captures.values_at(*%w[leading id url title])
      IdDef.new(id: id, url: url, title: title||"", indent: leading.size, line: match.string, lnb: lnb)
    end

    module_function def _make_indent(match, lnb)
      leading_spaces, more_spaces, rest = match.captures
      Indent.new(
        content: "#{more_spaces}#{rest}",
        indent: leading_spaces.size + more_spaces.size,
        level: leading_spaces.size / 4,
        line: match.string,
        lnb: lnb)
    end

    module_function def _make_ol_list_item(match, lnb)
      leading, bullet, spaces = match.values_at(1, 2, 3)
      sl = spaces.size
      sl1 = sl > 3 ? 1 : sl.succ
      sl2 = sl1 + bullet.size
      ListItem.new(
        type: :ol,
        bullet: bullet,
        content: match.values_at(3,4).join,
        indent: leading.size,
        line: match.string,
        list_indent:  leading.size + sl2,
        lnb: lnb)
    end

    module_function def _make_table_line match, lnb
      leading = match[1]
      body = match
        .string
        .strip
        .sub(%r{\A\|+},"")
        .sub(%r{\|+\z},"")

      columns = _split_table_columns(body)

      TableLine.new(
        columns: columns,
        content: match.string,
        indent: leading.size,
        is_header: _determine_if_header(columns),
        line: match.string,
        lnb: lnb)
    end

    module_function def _make_table_gfm_line(match, lnb)
      leading = match[1]
      columns = _split_table_columns(match.string)
      TableLine.new( content: match.string, columns: columns, is_header: _determine_if_header(columns), indent: leading.size, line: match.string, lnb: lnb)
    end

    module_function def _make_text(match, lnb)
      Text.new(
        content: match[2],
        indent: match[1].size,
        line: match.string,
        lnb: lnb)
    end

    module_function def _make_ul_list_item(match, lnb)
      leading, bullet, _spaces = match.values_at(1, 2, 3)
      ListItem.new(
        bullet: bullet,
        content: match.values_at(3, 4).join,
        indent: leading.size,
        initial_indent: 0,
        line: match.string,
        list_indent: match.values_at(1, 2, 3).join.size.succ,
        lnb: lnb,
        type: :ul)
    end

    module_function def _determine_if_header(columns)
      columns
        .all?{ |col| TableColumnRgx.match?(col) }
    end


    module_function def _split_table_columns(line)
      line
        .split(%r{(?<!\\)\|})
        .map(&:strip)
        .map{ |col| col.gsub(%r{\\\|}, "|") }
    end
  end
end
