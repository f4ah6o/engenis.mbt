///|
/// HdaAttrs::new は空の属性セットを作成する
test "HdaAttrs::new creates empty attrs" {
  let attrs = @hda.HdaAttrs::new()
  assert_eq(attrs.attrs.length(), 0)
}

///|
/// HdaAttrs::get は hx-get 属性を設定する
test "HdaAttrs::get sets hx-get" {
  let attrs = @hda.HdaAttrs::new().get("/api/data")
  let value = attrs.attrs.get("hx-get")
  match value {
    Some(v) => assert_eq(v, "/api/data")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::post は hx-post 属性を設定する
test "HdaAttrs::post sets hx-post" {
  let attrs = @hda.HdaAttrs::new().post("/api/create")
  let value = attrs.attrs.get("hx-post")
  match value {
    Some(v) => assert_eq(v, "/api/create")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::put は hx-put 属性を設定する
test "HdaAttrs::put sets hx-put" {
  let attrs = @hda.HdaAttrs::new().put("/api/update")
  let value = attrs.attrs.get("hx-put")
  match value {
    Some(v) => assert_eq(v, "/api/update")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::delete は hx-delete 属性を設定する
test "HdaAttrs::delete sets hx-delete" {
  let attrs = @hda.HdaAttrs::new().delete("/api/remove")
  let value = attrs.attrs.get("hx-delete")
  match value {
    Some(v) => assert_eq(v, "/api/remove")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::patch は hx-patch 属性を設定する
test "HdaAttrs::patch sets hx-patch" {
  let attrs = @hda.HdaAttrs::new().patch("/api/modify")
  let value = attrs.attrs.get("hx-patch")
  match value {
    Some(v) => assert_eq(v, "/api/modify")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::swap は hx-swap 属性を設定する
test "HdaAttrs::swap sets hx-swap" {
  let attrs = @hda.HdaAttrs::new().swap(@html.Swap::InnerHTML)
  let value = attrs.attrs.get("hx-swap")
  match value {
    Some(v) => assert_eq(v, "innerHTML")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::swap は outerHTML を設定できる
test "HdaAttrs::swap sets hx-swap with OuterHTML" {
  let attrs = @hda.HdaAttrs::new().swap(@html.Swap::OuterHTML)
  let value = attrs.attrs.get("hx-swap")
  match value {
    Some(v) => assert_eq(v, "outerHTML")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::target は hx-target 属性を設定する
test "HdaAttrs::target sets hx-target" {
  let attrs = @hda.HdaAttrs::new().target("#main")
  let value = attrs.attrs.get("hx-target")
  match value {
    Some(v) => assert_eq(v, "#main")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::trigger は hx-trigger 属性を設定する
test "HdaAttrs::trigger sets hx-trigger" {
  let attrs = @hda.HdaAttrs::new().trigger(@html.Trigger::Event("click"))
  let value = attrs.attrs.get("hx-trigger")
  match value {
    Some(v) => assert_eq(v, "click")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::on はイベントを設定する
test "HdaAttrs::on sets trigger with event" {
  let attrs = @hda.HdaAttrs::new().on("click")
  let value = attrs.attrs.get("hx-trigger")
  match value {
    Some(v) => assert_eq(v, "click")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::push_url は hx-push-url 属性を設定する
test "HdaAttrs::push_url sets hx-push-url" {
  let attrs = @hda.HdaAttrs::new().push_url("/new-path")
  let value = attrs.attrs.get("hx-push-url")
  match value {
    Some(v) => assert_eq(v, "/new-path")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::confirm は hx-confirm 属性を設定する
test "HdaAttrs::confirm sets hx-confirm" {
  let attrs = @hda.HdaAttrs::new().confirm("Are you sure?")
  let value = attrs.attrs.get("hx-confirm")
  match value {
    Some(v) => assert_eq(v, "Are you sure?")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::disable は hx-disable 属性を設定する
test "HdaAttrs::disable sets hx-disable" {
  let attrs = @hda.HdaAttrs::new().disable()
  let value = attrs.attrs.get("hx-disable")
  match value {
    Some(v) => assert_eq(v, "true")
    None => assert_true(false)
  }
}

///|
/// HdaAttrs::to_html_attrs は html.Attrs に変換する
test "HdaAttrs::to_html_attrs converts correctly" {
  let hda_attrs = @hda.HdaAttrs::new().post("/api/test").target("#main")
  let html_attrs = hda_attrs.to_html_attrs()
  // 変換された属性の数を確認
  assert_eq(html_attrs.attrs.length(), 2)
}

///|
/// HdaAttrs はメソッドチェーンをサポートする
test "HdaAttrs supports method chaining" {
  let attrs = @hda.HdaAttrs::new()
    .post("/api/test")
    .target("#main")
    .swap(@html.Swap::InnerHTML)
    .confirm("Are you sure?")
  assert_eq(attrs.attrs.length(), 4)
}
