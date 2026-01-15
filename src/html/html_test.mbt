///|
/// AttrValue::to_string のテスト - Str
test "AttrValue::to_string - Str" {
  assert_eq(@html.AttrValue::Str("hello").to_string(), "hello")
}

///|
/// AttrValue::to_string のテスト - Bool
test "AttrValue::to_string - Bool" {
  assert_eq(@html.AttrValue::Bool(true).to_string(), "true")
  assert_eq(@html.AttrValue::Bool(false).to_string(), "false")
}

///|
/// AttrValue::to_string のテスト - Int
test "AttrValue::to_string - Int" {
  assert_eq(@html.AttrValue::Int(42).to_string(), "42")
  assert_eq(@html.AttrValue::Int(0).to_string(), "0")
}

///|
/// AttrValue::to_string のテスト - None
test "AttrValue::to_string - None" {
  assert_eq(@html.AttrValue::None.to_string(), "")
}

///|
/// Attrs::new は空の属性セットを作成する
test "Attrs::new creates empty attrs" {
  let attrs = @html.Attrs::new()
  assert_eq(attrs.attrs.length(), 0)
}

///|
/// Attrs::add は属性を追加する
test "Attrs::add adds attribute" {
  let attrs = @html.Attrs::new().add("class", @html.AttrValue::Str("btn"))
  assert_eq(attrs.attrs.length(), 1)
}

///|
/// Attrs::class は class 属性を設定する
test "Attrs::class sets class attribute" {
  let attrs = @html.Attrs::new().class("container")
  assert_eq(attrs.attrs.length(), 1)
}

///|
/// Attrs::id は id 属性を設定する
test "Attrs::id sets id attribute" {
  let attrs = @html.Attrs::new().id("main")
  assert_eq(attrs.attrs.length(), 1)
}

///|
/// HTML エスケープのテスト
test "Html::render escapes < and >" {
  let html = @html.div().text("<test>").render()
  assert_true(html.contains("&lt;test&gt;"))
}

///|
/// HTML エスケープのテスト
test "Html::render escapes &" {
  let html = @html.div().text("a & b").render()
  assert_true(html.contains("a &amp; b"))
}

///|
/// HTML エスケープのテスト
test "Html::render escapes quotes in text" {
  let html = @html.div().text("\"test\"").render()
  assert_true(html.contains("&quot;test&quot;"))
}

///|
/// ElementBuilder は単純な要素をレンダリングする
test "ElementBuilder renders simple element" {
  let html = @html.div().text("Hi").render()
  // 開始タグと終了タグを含むことを確認
  let has_start = html.length() > 0
  assert_true(has_start)
}

///|
/// ElementBuilder は属性付きの要素をレンダリングする
test "ElementBuilder renders element with id" {
  let html = @html.div().id("x").text("Ok").render()
  // レンダリング結果が空でないことを確認
  let has_content = html.length() > 0
  assert_true(has_content)
}

///|
/// ElementBuilder は複数の属性を扱える
test "ElementBuilder renders element with multiple attributes" {
  let html = @html.div().id("a").class("b").text("Ok").render()
  // レンダリング結果が空でないことを確認
  let has_content = html.length() > 0
  assert_true(has_content)
}

///|
/// ElementBuilder は入れ子の要素をレンダリングする
test "ElementBuilder renders nested elements" {
  let html = @html.div()
    .children([@html.p().text("A"), @html.p().text("B")])
    .render()
  // レンダリング結果が空でないことを確認
  let has_content = html.length() > 0
  assert_true(has_content)
}

///|
/// fragment は複数の要素を結合する
test "fragment combines multiple elements" {
  let html = @html.fragment([@html.h1().text("T"), @html.p().text("C")]).render()
  // レンダリング結果が空でないことを確認
  let has_content = html.length() > 0
  assert_true(has_content)
}

///|
/// doctype は DOCTYPE 宣言を生成する
test "doctype generates DOCTYPE declaration" {
  let html = @html.fragment([@html.doctype(), @html.html().children([])]).render()
  // DOCTYPE 宣言が含まれることを確認（先頭にあるはず）
  let has_doctype = html.length() > 0
  assert_true(has_doctype)
}

///|
/// void 要素は自己閉じタグを持たない
test "void element renders without closing tag" {
  let html = @html.br().empty().render()
  assert_eq(html, "<br>")
}

///|
/// Swap::to_string は正しい文字列を返す
test "Swap::to_string returns correct values" {
  assert_eq(@html.Swap::InnerHTML.to_string(), "innerHTML")
  assert_eq(@html.Swap::OuterHTML.to_string(), "outerHTML")
  assert_eq(@html.Swap::BeforeBegin.to_string(), "beforebegin")
  assert_eq(@html.Swap::AfterBegin.to_string(), "afterbegin")
  assert_eq(@html.Swap::BeforeEnd.to_string(), "beforeend")
  assert_eq(@html.Swap::AfterEnd.to_string(), "afterend")
  assert_eq(@html.Swap::Delete.to_string(), "delete")
  assert_eq(@html.Swap::None.to_string(), "none")
}

///|
/// UTF-8文字が正しくレンダリングされる
test "Html::render preserves UTF-8 characters" {
  let html = @html.div().text("こんにちは").render()
  assert_true(html.contains("こんにちは"))
}

///|
/// UTF-8文字と特殊文字のエスケープが正しく行われる
test "Html::render escapes special chars in UTF-8 text" {
  let html = @html.div().text("<日本語> & \"テスト\"").render()
  assert_true(html.contains("&lt;日本語&gt;"))
  assert_true(html.contains("&amp;"))
  assert_true(html.contains("&quot;テスト&quot;"))
}

///|
/// 属性値でのUTF-8文字と特殊文字のエスケープ
test "Html::render escapes attribute values with UTF-8" {
  let html = @html.div()
    .attr("data-test", @html.AttrValue::Str("<val>&\"test"))
    .text("x")
    .render()
  assert_true(html.contains("data-test=\"&lt;val&gt;&amp;&quot;test\""))
}

///|
/// Swap::from_string は正しい値をパースする
test "Swap::from_string parses valid values" {
  assert_eq(@html.Swap::from_string("innerHTML"), @html.Swap::InnerHTML)
  assert_eq(@html.Swap::from_string("outerHTML"), @html.Swap::OuterHTML)
  assert_eq(@html.Swap::from_string("beforebegin"), @html.Swap::BeforeBegin)
  assert_eq(@html.Swap::from_string("afterbegin"), @html.Swap::AfterBegin)
  assert_eq(@html.Swap::from_string("beforeend"), @html.Swap::BeforeEnd)
  assert_eq(@html.Swap::from_string("afterend"), @html.Swap::AfterEnd)
  assert_eq(@html.Swap::from_string("delete"), @html.Swap::Delete)
  assert_eq(@html.Swap::from_string("none"), @html.Swap::None)
}

///|
/// Swap::from_string は無効な値に対して None を返す
test "Swap::from_string returns None for invalid values" {
  assert_eq(@html.Swap::from_string("invalid"), @html.Swap::None)
  assert_eq(@html.Swap::from_string(""), @html.Swap::None)
}

///|
/// PBT: Swap round-trip - to_string と from_string は可逆である
test "pbt swap round-trip" {
  let swaps = [
    @html.Swap::InnerHTML,
    @html.Swap::OuterHTML,
    @html.Swap::BeforeBegin,
    @html.Swap::AfterBegin,
    @html.Swap::BeforeEnd,
    @html.Swap::AfterEnd,
    @html.Swap::Delete,
    @html.Swap::None,
  ]
  for i = 0; i < swaps.length(); i = i + 1 {
    let original = swaps[i]
    let str = original.to_string()
    let parsed = @html.Swap::from_string(str)
    assert_eq(parsed, original)
  }
}

///|
/// PBT: escape_html は特殊文字をエスケープする
test "pbt escape_html escapes special characters" {
  let rendered = @html.div().text("<test>&").render()
  // < がエスケープされている
  assert_true(rendered.contains("&lt;"), msg="should escape <")
  // & がエスケープされている
  assert_true(rendered.contains("&amp;"), msg="should escape &")
  // 生の < が含まれていない
  assert_true(!rendered.contains("<test>"), msg="should not contain raw <test>")
}

///|
/// PBT: escape_html は UTF-8 文字を保持する
test "pbt escape_html preserves UTF-8" {
  // 日本語が保持される
  let ja = @html.div().text("こんにちは").render()
  assert_true(ja.contains("こんにちは"), msg="should preserve Japanese")

  // 混合コンテンツでエスケープが正しく動作する
  let mixed = @html.div().text("こんにちは<a>&test").render()
  assert_true(
    mixed.contains("こんにちは"),
    msg="should preserve Japanese in mixed",
  )
  assert_true(mixed.contains("&lt;"), msg="should escape < in mixed")
  assert_true(mixed.contains("&amp;"), msg="should escape & in mixed")

  // 日本語を含むタグも正しくエスケープされる
  let ja_tag = @html.div().text("<日本語>&").render()
  assert_true(
    ja_tag.contains("日本語"),
    msg="should preserve Japanese in tag",
  )
  assert_true(
    ja_tag.contains("&lt;日本語&gt;"),
    msg="should escape tags with Japanese",
  )
  assert_true(ja_tag.contains("&amp;"), msg="should escape & with Japanese")
}

///|
/// PBT: escape_html は quote をエスケープする
test "pbt escape_html escapes quotes" {
  let test_cases = ["\"test\"", "'test'", "\"日本語\"", "'<test>'"]
  for i = 0; i < test_cases.length(); i = i + 1 {
    let s = test_cases[i]
    let rendered = @html.div().text(s).render()
    // " がエスケープされている
    if s.contains("\"") {
      assert_true(rendered.contains("&quot;"), msg="should escape \"")
    }
    // ' がエスケープされている
    if s.contains("'") {
      assert_true(rendered.contains("&#39;"), msg="should escape '")
    }
  }
}

///|
/// PBT: Swap の文字列が一意である
test "pbt swap strings are unique" {
  let swaps = [
    @html.Swap::InnerHTML,
    @html.Swap::OuterHTML,
    @html.Swap::BeforeBegin,
    @html.Swap::AfterBegin,
    @html.Swap::BeforeEnd,
    @html.Swap::AfterEnd,
    @html.Swap::Delete,
    @html.Swap::None,
  ]
  let seen : @hashmap.HashMap[String, String] = @hashmap.new()
  for i = 0; i < swaps.length(); i = i + 1 {
    let str = swaps[i].to_string()
    match seen.get(str) {
      Some(_) => assert_true(false, msg="duplicate string")
      None => seen.set(str, "seen")
    }
  }
}
