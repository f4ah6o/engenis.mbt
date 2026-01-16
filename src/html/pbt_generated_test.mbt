///|
/// Property-Based Tests for html package
/// Auto-generated from engenis.pbt.mbt.md

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
  let with_one = empty.add("key1", AttrValue::Str("val1"))
  let with_two = with_one.add("key2", AttrValue::Str("val2"))

  assert_eq(with_one.attrs.length(), 1)
  assert_eq(with_two.attrs.length(), 2)
}

///|
test "prop_hx_swap_preserves_length" {
  let attrs1 = Attrs::new()
  let attrs2 = attrs1.hx_swap("innerHTML")
  let attrs3 = attrs2.hx_swap("outerHTML")

  assert_eq(attrs2.attrs.length(), 1)
  assert_eq(attrs3.attrs.length(), 1)
}

///|
test "prop_html_render_escapes_lt_gt" {
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
test "prop_html_render_preserves_utf8" {
  let ja = div().text("こんにちは").render()
  assert_true(ja.contains("こんにちは"), msg="should preserve Japanese")

  let mixed = div().text("<日本語>&").render()
  assert_true(mixed.contains("日本語"), msg="should preserve Japanese in mixed")
  assert_true(mixed.contains("&lt;日本語&gt;"), msg="should escape tags with Japanese")
}
