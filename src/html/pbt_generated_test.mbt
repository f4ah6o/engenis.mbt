///|
/// Property-Based Tests for html package
/// Auto-generated from html.pbt.md

///|
test "prop_swap_roundtrip" {
  let swaps = [
    Swap::InnerHTML,
    Swap::OuterHTML,
    Swap::BeforeBegin,
    Swap::AfterBegin,
    Swap::BeforeEnd,
    Swap::AfterEnd,
    Swap::Delete,
    Swap::None,
  ]
  for i = 0; i < swaps.length(); i = i + 1 {
    let original = swaps[i]
    let str = original.to_string()
    let parsed = Swap::from_string(str)
    assert_eq(parsed, original, msg="round-trip failed for " + str)
  }
}

///|
test "prop_swap_from_string_unknown_returns_none" {
  let unknown = Swap::from_string("unknown_swap_value")
  assert_eq(unknown, Swap::None)
}

///|
test "prop_attrvalue_to_string_preserves_content" {
  let s = AttrValue::Str("hello")
  assert_eq(s.to_string(), "hello")
  let b_true = AttrValue::Bool(true)
  assert_eq(b_true.to_string(), "true")
  let b_false = AttrValue::Bool(false)
  assert_eq(b_false.to_string(), "false")
  let i = AttrValue::Int(42)
  assert_eq(i.to_string(), "42")
  let n = AttrValue::None
  assert_eq(n.to_string(), "")
}

///|
test "prop_attrs_add_increases_length" {
  let empty = Attrs::new()
  assert_eq(empty.attrs.length(), 0)
  let with_one = empty.add("key1", AttrValue::Str("val1"))
  assert_eq(with_one.attrs.length(), 1)
  let with_two = with_one.add("key2", AttrValue::Str("val2"))
  assert_eq(with_two.attrs.length(), 2)
  let with_duplicate = with_two.add("key1", AttrValue::Str("new_val"))
  assert_eq(with_duplicate.attrs.length(), 3)
}

///|
test "prop_hx_swap_adds_attribute" {
  let attrs1 = Attrs::new()
  assert_eq(attrs1.attrs.length(), 0)
  let attrs2 = attrs1.hx_swap("innerHTML")
  assert_eq(attrs2.attrs.length(), 1)

  // Note: hx_swap does NOT replace existing attributes (Issue #37)
  // It simply prepends a new attribute, causing duplicates
  let attrs3 = attrs2.hx_swap("outerHTML")
  assert_eq(attrs3.attrs.length(), 2)
}

///|
test "prop_hx_swap_safe_adds_attribute" {
  let attrs1 = Attrs::new()
  assert_eq(attrs1.attrs.length(), 0)
  let attrs2 = attrs1.hx_swap_safe(Swap::InnerHTML)
  assert_eq(attrs2.attrs.length(), 1)

  // Note: hx_swap_safe does NOT replace existing attributes (Issue #37)
  // It simply prepends a new attribute, causing duplicates
  let attrs3 = attrs2.hx_swap_safe(Swap::OuterHTML)
  assert_eq(attrs3.attrs.length(), 2)
}

///|
test "prop_hx_delete_reduces_length" {
  let attrs1 = Attrs::new()
  assert_eq(attrs1.attrs.length(), 0)
  let attrs2 = attrs1.hx_delete("/delete")
  assert_eq(attrs2.attrs.length(), 1)
}

///|
test "prop_html_render_escapes_special_chars" {
  let html = div().text("<test>").render()
  assert_true(html.contains("&lt;test&gt;"), msg="should escape < and >")
  assert_true(!html.contains("<test>"), msg="should not contain raw <test>")
}

///|
test "prop_html_render_escapes_ampersand" {
  let html = div().text("a & b").render()
  assert_true(html.contains("a &amp; b"), msg="should escape &")
}

///|
test "prop_html_render_escapes_quotes" {
  let html = div().text("\"quoted\"").render()
  assert_true(html.contains("&quot;quoted&quot;"), msg="should escape quotes")
}

///|
test "prop_html_render_preserves_utf8" {
  let ja = div().text("こんにちは").render()
  assert_true(ja.contains("こんにちは"), msg="should preserve Japanese")
  let mixed = div().text("<日本語>&").render()
  assert_true(
    mixed.contains("日本語"),
    msg="should preserve Japanese in mixed",
  )
  assert_true(
    mixed.contains("&lt;日本語&gt;"),
    msg="should escape tags with Japanese",
  )
}

///|
test "prop_attrs_merge_prefer_takes_precedence" {
  let fallback = Attrs::new().add("class", AttrValue::Str("fallback"))
  let prefer = Attrs::new().add("class", AttrValue::Str("prefer"))
  let merged = Attrs::merge(prefer, fallback)

  // Should have 1 attribute (prefer's class wins)
  assert_eq(merged.attrs.length(), 1)
  assert_eq(merged.attrs[0].0, "class")
  match merged.attrs[0].1 {
    Str(s) => assert_eq(s, "prefer")
    _ => assert_true(false, msg="should be Str variant")
  }
}

///|
test "prop_attrs_merge_combines_unique_keys" {
  let fallback = Attrs::new().add("class", AttrValue::Str("fallback"))
  let prefer = Attrs::new().add("id", AttrValue::Str("unique"))
  let merged = Attrs::merge(prefer, fallback)

  // Should have 2 attributes
  assert_eq(merged.attrs.length(), 2)
}

///|
test "prop_trigger_mod_to_string_formats_correctly" {
  assert_eq(TriggerMod::Once.to_string(), "once")
  assert_eq(TriggerMod::Changed.to_string(), "changed")
  assert_eq(TriggerMod::Delay(100).to_string(), "delay:100ms")
  assert_eq(TriggerMod::Throttle(200).to_string(), "throttle:200ms")
  assert_eq(TriggerMod::From("#form").to_string(), "from:#form")
  assert_eq(TriggerMod::Target("#btn").to_string(), "target:#btn")
}

///|
test "prop_trigger_to_string_combines_mods" {
  let trigger = Trigger::EventWithMods("click", [
    TriggerMod::Once,
    TriggerMod::From("#btn"),
  ])
  let result = trigger.to_string()
  assert_true(result.contains("click"), msg="should contain event name")
  assert_true(result.contains("once"), msg="should contain once modifier")
  assert_true(result.contains("from:#btn"), msg="should contain from modifier")
}

///|
test "prop_html_raw_preserves_content" {
  let raw_html = raw("<script>alert('xss')</script>")
  let rendered = raw_html.render()
  assert_true(rendered.contains("<script>"), msg="should preserve raw tags")
  assert_true(rendered.contains("alert('xss')"), msg="should preserve raw content")
}

///|
test "prop_html_raw_no_escaping" {
  let raw_content = raw("<div>&\"'</div>")
  let rendered = raw_content.render()
  assert_true(rendered.contains("<div>"), msg="should not escape <")
  assert_true(rendered.contains("&"), msg="should not escape &")
  assert_true(rendered.contains("\""), msg="should not escape quotes")
}

///|
test "prop_html_when_true_renders_then" {
  let html = when(true, div().text("shown"))
  let rendered = html.render()
  assert_true(rendered.contains("shown"), msg="should render then branch")
  assert_true(!rendered.contains("hidden"), msg="should not render else content")
}

///|
test "prop_html_when_false_no_else_renders_empty" {
  let html = when(false, div().text("hidden"))
  let rendered = html.render()
  assert_eq(rendered, "", msg="should render empty string")
}

///|
test "prop_html_when_else_false_renders_else" {
  let html = when_else(false, div().text("then"), div().text("else"))
  let rendered = html.render()
  assert_true(rendered.contains("else"), msg="should render else branch")
  assert_true(!rendered.contains("then"), msg="should not render then content")
}

///|
test "prop_fragment_empty_renders_empty" {
  let frag = fragment([])
  let rendered = frag.render()
  assert_eq(rendered, "", msg="empty fragment should render empty string")
}

///|
test "prop_fragment_combines_children" {
  let frag = fragment([p().text("first"), p().text("second")])
  let rendered = frag.render()
  assert_true(rendered.contains("<p>first</p>"), msg="should contain first child")
  assert_true(rendered.contains("<p>second</p>"), msg="should contain second child")
  assert_true(!rendered.contains("<fragment>"), msg="should not have wrapper tag")
}

///|
test "prop_fragment_nested" {
  let inner = fragment([span().text("a")])
  let outer = fragment([inner, span().text("b")])
  let rendered = outer.render()
  assert_true(rendered.contains("<span>a</span>"), msg="should contain inner")
  assert_true(rendered.contains("<span>b</span>"), msg="should contain outer")
}

///|
test "prop_void_element_no_closing_tag" {
  let br_html = br().empty()
  let br_rendered = br_html.render()
  assert_true(br_rendered.contains("<br>"), msg="should have br tag")
  assert_true(!br_rendered.contains("</br>"), msg="should not have closing br")

  let hr_html = hr().empty()
  let hr_rendered = hr_html.render()
  assert_true(hr_rendered.contains("<hr>"), msg="should have hr tag")
  assert_true(!hr_rendered.contains("</hr>"), msg="should not have closing hr")

  let img_html = img().empty()
  let img_rendered = img_html.render()
  assert_true(img_rendered.contains("<img>"), msg="should have img tag")
  assert_true(!img_rendered.contains("</img>"), msg="should not have closing img")

  let input_html = input().empty()
  let input_rendered = input_html.render()
  assert_true(input_rendered.contains("<input>"), msg="should have input tag")
  assert_true(!input_rendered.contains("</input>"), msg="should not have closing input")

  let meta_html = meta().empty()
  let meta_rendered = meta_html.render()
  assert_true(meta_rendered.contains("<meta>"), msg="should have meta tag")
  assert_true(!meta_rendered.contains("</meta>"), msg="should not have closing meta")

  let link_html = link_tag().empty()
  let link_rendered = link_html.render()
  assert_true(link_rendered.contains("<link>"), msg="should have link tag")
  assert_true(!link_rendered.contains("</link>"), msg="should not have closing link")
}

///|
test "prop_non_void_element_has_closing_tag" {
  let div_html = div().empty()
  let div_rendered = div_html.render()
  assert_true(div_rendered.contains("<div>"), msg="should have div open")
  assert_true(div_rendered.contains("</div>"), msg="should have div close")

  let p_html = p().empty()
  let p_rendered = p_html.render()
  assert_true(p_rendered.contains("<p>"), msg="should have p open")
  assert_true(p_rendered.contains("</p>"), msg="should have p close")

  let span_html = span().empty()
  let span_rendered = span_html.render()
  assert_true(span_rendered.contains("<span>"), msg="should have span open")
  assert_true(span_rendered.contains("</span>"), msg="should have span close")
}

///|
test "prop_escape_attr_escapes_quotes" {
  let html = div().attr("title", Str("hello \"world\"")).empty()
  let rendered = html.render()
  assert_true(rendered.contains("&quot;"), msg="should escape quotes in attribute")
}

///|
test "prop_escape_attr_escapes_ampersand" {
  let html = div().attr("data", Str("a & b")).empty()
  let rendered = html.render()
  assert_true(rendered.contains("&amp;"), msg="should escape ampersand in attribute")
}

///|
test "prop_escape_attr_escapes_lt_gt" {
  let html = div().attr("content", Str("<tag>")).empty()
  let rendered = html.render()
  assert_true(rendered.contains("&lt;"), msg="should escape < in attribute")
  assert_true(rendered.contains("&gt;"), msg="should escape > in attribute")
}

///|
test "prop_elementbuilder_text_escapes" {
  let html = div().text("<script>")
  let rendered = html.render()
  assert_true(rendered.contains("&lt;script&gt;"), msg="should escape text content")
}

///|
test "prop_elementbuilder_empty_no_children" {
  let html = div().empty()
  let rendered = html.render()
  assert_true(rendered.contains("<div></div>"), msg="should have empty div")
}

///|
test "prop_elementbuilder_child_single" {
  let html = div().child(span().text("child"))
  let rendered = html.render()
  assert_true(rendered.contains("<div><span>child</span></div>"), msg="should wrap child")
}

///|
test "prop_elementbuilder_children_multiple" {
  let html = div().children([span().text("a"), span().text("b")])
  let rendered = html.render()
  assert_true(rendered.contains("<span>a</span>"), msg="should contain first child")
  assert_true(rendered.contains("<span>b</span>"), msg="should contain second child")
}

///|
test "prop_elementbuilder_attr_adds" {
  let html = div().attr("id", Str("test")).empty()
  let rendered = html.render()
  assert_true(rendered.contains("id=\"test\""), msg="should have id attribute")
}

///|
test "prop_elementbuilder_data_prefixes" {
  let html = div().data("test", "value").empty()
  let rendered = html.render()
  assert_true(rendered.contains("data-test=\"value\""), msg="should have data- prefix")
}

///|
test "prop_helper_doctype_constant" {
  let doc = doctype()
  let rendered = doc.render()
  assert_eq(rendered, "<!DOCTYPE html>", msg="should return doctype string")
}

///|
test "prop_helper_charset_meta" {
  let meta_charset = charset("utf-8")
  let rendered = meta_charset.render()
  assert_true(rendered.contains("<meta"), msg="should be meta tag")
  assert_true(rendered.contains("charset=\"utf-8\""), msg="should have charset attribute")
  assert_true(!rendered.contains("</meta>"), msg="should be void element")
}

///|
test "prop_helper_viewport_meta" {
  let meta_viewport = viewport("width=device-width")
  let rendered = meta_viewport.render()
  assert_true(rendered.contains("<meta"), msg="should be meta tag")
  assert_true(rendered.contains("name=\"viewport\""), msg="should have name=viewport")
  assert_true(rendered.contains("content=\"width=device-width\""), msg="should have content")
}

///|
test "prop_helper_stylesheet_link" {
  let css = stylesheet("/style.css")
  let rendered = css.render()
  assert_true(rendered.contains("<link"), msg="should be link tag")
  assert_true(rendered.contains("rel=\"stylesheet\""), msg="should have rel=stylesheet")
  assert_true(rendered.contains("href=\"/style.css\""), msg="should have href")
  assert_true(!rendered.contains("</link>"), msg="should be void element")
}

///|
test "prop_trigger_multiple_joins_with_comma" {
  let trigger = Trigger::Multiple([Trigger::Event("click"), Trigger::Event("change"), Trigger::Event("submit")])
  let result = trigger.to_string()
  assert_true(result.contains("click"), msg="should contain click")
  assert_true(result.contains("change"), msg="should contain change")
  assert_true(result.contains("submit"), msg="should contain submit")
  assert_true(result.contains(", "), msg="should have comma separator")
}

///|
test "prop_trigger_event_with_empty_mods" {
  let trigger = Trigger::EventWithMods("load", [])
  let result = trigger.to_string()
  assert_eq(result, "load", msg="should return only event name with no mods")
}

///|
test "prop_nested_elements_preserve_structure" {
  let html = div().child(
    p().child(
      span().text("nested")
    )
  )
  let rendered = html.render()
  assert_true(rendered.contains("<div><p><span>nested</span></p></div>"), msg="should preserve nesting")
}

///|
test "prop_deeply_nested_rendering" {
  let html = div().child(
    div().child(
      div().child(
        div().child(
          span().text("deep")
        )
      )
    )
  )
  let rendered = html.render()
  assert_true(rendered.contains("deep"), msg="should render deep content")
  // Should have 4 opening div tags
  let div_count = rendered.split("<div>").to_array().length() - 1
  assert_eq(div_count, 4, msg="should have 4 div levels")
}

///|
test "prop_mixed_content_text_and_elements" {
  let html = div().children([text("before"), span().text("element"), text("after")])
  let rendered = html.render()
  assert_true(rendered.contains("before"), msg="should have text before")
  assert_true(rendered.contains("<span>element</span>"), msg="should have element")
  assert_true(rendered.contains("after"), msg="should have text after")
}

///|
test "prop_empty_text_renders_nothing" {
  let html = text("")
  let rendered = html.render()
  assert_eq(rendered, "", msg="empty text should render nothing")
}

///|
test "prop_special_chars_preserved_in_raw" {
  let raw_html = raw("<>&\"'")
  let rendered = raw_html.render()
  assert_true(rendered.contains("<"), msg="should preserve <")
  assert_true(rendered.contains(">"), msg="should preserve >")
  assert_true(rendered.contains("&"), msg="should preserve &")
  assert_true(rendered.contains("\""), msg="should preserve quotes")
}

///|
test "prop_unicode_attributes" {
  let html = div().attr("title", Str("こんにちは")).empty()
  let rendered = html.render()
  assert_true(rendered.contains("こんにちは"), msg="should preserve unicode in attributes")
}
