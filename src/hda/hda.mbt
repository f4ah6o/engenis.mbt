///|
/// HDA属性ビルダー（簡易実装）
pub(all) struct HdaAttrs {
  // 簡易実装 - 文字列で属性を保持
  attrs : @hashmap.HashMap[String, String]
}

///|
pub fn HdaAttrs::new() -> HdaAttrs {
  { attrs: @hashmap.new() }
}

///|
// 内部ヘルパー: 属性を追加して新しい HdaAttrs を返す
fn HdaAttrs::_add(self : HdaAttrs, key : String, value : String) -> HdaAttrs {
  let new_attrs = self.attrs.copy()
  new_attrs.set(key, value)
  { attrs: new_attrs }
}

///|
pub fn HdaAttrs::get(self : HdaAttrs, url : String) -> HdaAttrs {
  self._add("hx-get", url)
}

///|
pub fn HdaAttrs::post(self : HdaAttrs, url : String) -> HdaAttrs {
  self._add("hx-post", url)
}

///|
pub fn HdaAttrs::put(self : HdaAttrs, url : String) -> HdaAttrs {
  self._add("hx-put", url)
}

///|
pub fn HdaAttrs::delete(self : HdaAttrs, url : String) -> HdaAttrs {
  self._add("hx-delete", url)
}

///|
pub fn HdaAttrs::patch(self : HdaAttrs, url : String) -> HdaAttrs {
  self._add("hx-patch", url)
}

///|
pub fn HdaAttrs::swap(self : HdaAttrs, s : @html.Swap) -> HdaAttrs {
  self._add("hx-swap", s.to_string())
}

///|
pub fn HdaAttrs::target(self : HdaAttrs, selector : String) -> HdaAttrs {
  self._add("hx-target", selector)
}

///|
pub fn HdaAttrs::trigger(self : HdaAttrs, t : @html.Trigger) -> HdaAttrs {
  self._add("hx-trigger", t.to_string())
}

///|
pub fn HdaAttrs::on(self : HdaAttrs, event : String) -> HdaAttrs {
  self.trigger(@html.Trigger::Event(event))
}

///|
pub fn HdaAttrs::push_url(self : HdaAttrs, url : String) -> HdaAttrs {
  self._add("hx-push-url", url)
}

///|
pub fn HdaAttrs::confirm(self : HdaAttrs, message : String) -> HdaAttrs {
  self._add("hx-confirm", message)
}

///|
pub fn HdaAttrs::disable(self : HdaAttrs) -> HdaAttrs {
  self._add("hx-disable", "true")
}

///|
pub fn HdaAttrs::encoding(self : HdaAttrs, encoding : String) -> HdaAttrs {
  self._add("hx-encoding", encoding)
}

///|
pub fn HdaAttrs::headers(self : HdaAttrs, headers : String) -> HdaAttrs {
  self._add("hx-headers", headers)
}

///|
pub fn HdaAttrs::params(self : HdaAttrs, params : String) -> HdaAttrs {
  self._add("hx-vals", params)
}

///|
pub fn HdaAttrs::boost(self : HdaAttrs) -> HdaAttrs {
  self._add("hx-boost", "true")
}

///|
/// HdaAttrs を html.Attrs に変換
pub fn HdaAttrs::to_html_attrs(self : HdaAttrs) -> @html.Attrs {
  let entries = self.attrs.to_array()
  let mut html_attrs = @html.Attrs::new()
  for i = 0; i < entries.length(); i = i + 1 {
    let (key, value) = entries[i]
    html_attrs = html_attrs.add(key, @html.AttrValue::Str(value))
  }
  html_attrs
}
