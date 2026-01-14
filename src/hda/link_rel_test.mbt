///|
fn attr_value_to_string(value : @html.AttrValue) -> String {
  match value {
    @html.AttrValue::Str(s) => s
    @html.AttrValue::Bool(true) => "true"
    @html.AttrValue::Bool(false) => "false"
    @html.AttrValue::Int(i) => i.to_string()
    @html.AttrValue::None => ""
  }
}

///|
fn find_attr(attrs : @html.Attrs, key : String) -> String? {
  let entries = attrs.attrs
  for i = 0; i < entries.length(); i = i + 1 {
    let (k, v) = entries[i]
    if k == key {
      return Some(attr_value_to_string(v))
    }
  }
  None
}

///|
test "link rel builds hx attrs and rel" {
  let link = @hda.LinkRel::new(
      @hda.Rel::namespaced("counter", "inc"),
      @router.Route::post("/counter/inc"),
    )
    .target("#counter")
    .swap(@html.Swap::InnerHTML)
  let attrs = link.to_attrs()
  inspect(find_attr(attrs, "data-rel"), content="Some(\"counter:inc\")")
  inspect(find_attr(attrs, "hx-post"), content="Some(\"/counter/inc\")")
  inspect(find_attr(attrs, "hx-target"), content="Some(\"#counter\")")
  inspect(find_attr(attrs, "hx-swap"), content="Some(\"innerHTML\")")
}

///|
test "link rel maps get to hx-get" {
  let link = @hda.LinkRel::new(@hda.Rel::SelfRel, @router.Route::get("/"))
  let attrs = link.to_attrs()
  inspect(find_attr(attrs, "hx-get"), content="Some(\"/\")")
}

///|
test "link rel includes rel for link attrs" {
  let link = @hda.LinkRel::new(
    @hda.Rel::custom("counter:inc"),
    @router.Route::post("/counter/inc"),
  )
  let attrs = link.to_link_attrs()
  inspect(find_attr(attrs, "rel"), content="Some(\"counter:inc\")")
  inspect(find_attr(attrs, "data-rel"), content="Some(\"counter:inc\")")
}
