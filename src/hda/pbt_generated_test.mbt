///|
/// Property-Based Tests for hda package
/// Auto-generated from engenis.pbt.mbt.md

///|
test "prop_rel_to_string_matches_standard" {
  assert_eq(Rel::SelfRel.to_string(), "self")
  assert_eq(Rel::Next.to_string(), "next")
  assert_eq(Rel::Prev.to_string(), "prev")
  assert_eq(Rel::First.to_string(), "first")
  assert_eq(Rel::Last.to_string(), "last")
  assert_eq(Rel::Collection.to_string(), "collection")
  assert_eq(Rel::Item.to_string(), "item")
  assert_eq(Rel::Related.to_string(), "related")
  assert_eq(Rel::Search.to_string(), "search")
  assert_eq(Rel::Edit.to_string(), "edit")
  assert_eq(Rel::Create.to_string(), "create")
  assert_eq(Rel::Update.to_string(), "update")
  assert_eq(Rel::Delete.to_string(), "delete")
  assert_eq(Rel::Help.to_string(), "help")
  assert_eq(Rel::Profile.to_string(), "profile")
}

///|
test "prop_rel_custom_preserves_value" {
  let custom = Rel::Custom("my-rel")
  assert_eq(custom.to_string(), "my-rel")

  let namespaced = Rel::namespaced("ext", "action")
  assert_eq(namespaced.to_string(), "ext:action")
}

///|
test "prop_hdaattrs_to_html_attrs_preserves_entries" {
  let hda = HdaAttrs::new()
    .get("/api/data")
    .swap(@html.Swap::InnerHTML)
    .target("#output")

  let html = hda.to_html_attrs()
  assert_eq(html.attrs.length(), 3)
}

///|
test "prop_linkrel_to_attrs_includes_data_rel" {
  let route = @router.Route::get("/test")
  let link = LinkRel::new(Rel::Next, route)
  let attrs = link.to_attrs()

  let has_data_rel = attrs.attrs.any(fn((k, _)) { k == "data-rel" })
  assert_true(has_data_rel, msg="should have data-rel attribute")
}

///|
test "prop_linkrel_to_link_attrs_includes_rel" {
  let route = @router.Route::get("/test")
  let link = LinkRel::new(Rel::Prev, route)
  let attrs = link.to_link_attrs()

  let has_rel = attrs.attrs.any(fn((k, _)) { k == "rel" })
  assert_true(has_rel, msg="should have rel attribute")

  let has_data_rel = attrs.attrs.any(fn((k, _)) { k == "data-rel" })
  assert_true(has_data_rel, msg="should have data-rel attribute")
}
