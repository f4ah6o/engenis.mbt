///|
/// Property-Based Tests for http package
/// Auto-generated from http.pbt.md

///|
test "prop_method_to_string_valid" {
  assert_eq(Method::Get.to_string(), "Get")
  assert_eq(Method::Post.to_string(), "Post")
  assert_eq(Method::Put.to_string(), "Put")
  assert_eq(Method::Delete.to_string(), "Delete")
  assert_eq(Method::Patch.to_string(), "Patch")
}

///|
test "prop_hdaresponse_swap_preserves_length" {
  let resp1 = HdaResponseBuilder::new(200, "OK")
  assert_eq(resp1.headers.length(), 1)
  let resp2 = resp1.swap(InnerHTML)
  assert_eq(resp2.headers.length(), 2)
  let resp3 = resp2.swap(OuterHTML)
  assert_eq(resp3.headers.length(), 2)
}

///|
test "prop_hdaresponse_reswap_preserves_length" {
  let resp1 = HdaResponseBuilder::new(200, "OK")
  assert_eq(resp1.headers.length(), 1)
  let resp2 = resp1.reswap(InnerHTML)
  assert_eq(resp2.headers.length(), 2)
  let resp3 = resp2.reswap(OuterHTML)
  assert_eq(resp3.headers.length(), 2)
}

///|
test "prop_hdaresponse_push_url_increases_length" {
  let resp1 = HdaResponseBuilder::new(200, "OK")
  assert_eq(resp1.headers.length(), 1)
  let resp2 = resp1.push_url("/new")
  assert_eq(resp2.headers.length(), 2)
}

///|
test "prop_hdaresponse_trigger_after_swap_preserves_length" {
  let resp1 = HdaResponseBuilder::new(200, "OK")
  assert_eq(resp1.headers.length(), 1)
  let resp2 = resp1.trigger_after_swap("click")
  assert_eq(resp2.headers.length(), 2)
  let resp3 = resp2.trigger_after_swap("load")
  assert_eq(resp3.headers.length(), 2)
}

///|
test "prop_hdaresponse_combines_attributes" {
  let resp = HdaResponseBuilder::new(200, "OK")
    .swap(InnerHTML)
    .trigger("click")
    .target("#result")

  // Should have 4 headers (1 default + 3 added)
  assert_eq(resp.headers.length(), 4)
}

///|
test "prop_hdaresponse_content_preserved" {
  let content = "<div>test</div>"
  let resp = HdaResponseBuilder::new(200, "OK").html(content)
  assert_eq(resp.body, content)
}
