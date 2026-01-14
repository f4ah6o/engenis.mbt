///|
/// HDAレスポンスビルダー
pub(all) struct HdaResponseBuilder {
  status : Int
  reason : String
  headers : @hashmap.HashMap[String, String]
  body : String
}

///|
pub fn HdaResponseBuilder::new(
  status : Int,
  reason : String,
) -> HdaResponseBuilder {
  let headers = @hashmap.from_array([
    ("Content-Type", "text/html; charset=utf-8"),
  ])
  { status, reason, headers, body: "" }
}

///|
pub fn HdaResponseBuilder::header(
  self : HdaResponseBuilder,
  key : String,
  value : String,
) -> HdaResponseBuilder {
  let new_headers = self.headers.copy()
  new_headers.set(key, value)
  {
    status: self.status,
    reason: self.reason,
    headers: new_headers,
    body: self.body,
  }
}

///|
pub fn HdaResponseBuilder::swap(
  self : HdaResponseBuilder,
  s : @html.Swap,
) -> HdaResponseBuilder {
  self.header("HX-Reswap", s.to_string())
}

///|
pub fn HdaResponseBuilder::target(
  self : HdaResponseBuilder,
  selector : String,
) -> HdaResponseBuilder {
  self.header("HX-Retarget", selector)
}

///|
pub fn HdaResponseBuilder::trigger(
  self : HdaResponseBuilder,
  event : String,
) -> HdaResponseBuilder {
  self.header("HX-Trigger", event)
}

///|
pub fn HdaResponseBuilder::trigger_after_swap(
  self : HdaResponseBuilder,
  event : String,
) -> HdaResponseBuilder {
  self.header("HX-Trigger-After-Swap", event)
}

///|
pub fn HdaResponseBuilder::trigger_after_settle(
  self : HdaResponseBuilder,
  event : String,
) -> HdaResponseBuilder {
  self.header("HX-Trigger-After-Settle", event)
}

///|
pub fn HdaResponseBuilder::push_url(
  self : HdaResponseBuilder,
  url : String,
) -> HdaResponseBuilder {
  self.header("HX-Push-Url", url)
}

///|
pub fn HdaResponseBuilder::redirect(
  self : HdaResponseBuilder,
  url : String,
) -> HdaResponseBuilder {
  self.header("HX-Redirect", url)
}

///|
pub fn HdaResponseBuilder::replace_url(
  self : HdaResponseBuilder,
  url : String,
) -> HdaResponseBuilder {
  self.header("HX-Replace-Url", url)
}

///|
pub fn HdaResponseBuilder::reswap(
  self : HdaResponseBuilder,
  s : @html.Swap,
) -> HdaResponseBuilder {
  self.swap(s)
}

///|
pub fn HdaResponseBuilder::html(
  self : HdaResponseBuilder,
  content : String,
) -> HdaResponseBuilder {
  {
    status: self.status,
    reason: self.reason,
    headers: self.headers,
    body: content,
  }
}

///|
pub fn HdaResponseBuilder::build(self : HdaResponseBuilder) -> @http.Response {
  {
    status: self.status,
    reason: self.reason,
    headers: self.headers,
    body: @http.ResponseBody::Text(self.body),
  }
}

///|
/// HTMLレスポンスを作成
pub fn html_response(html : String) -> HdaResponseBuilder {
  HdaResponseBuilder::new(200, "OK").html(html)
}

///|
/// HDAレスポンスを作成
pub fn hda_response(
  html : String,
  swap? : @html.Swap = @html.Swap::InnerHTML,
  target? : String = "",
) -> HdaResponseBuilder {
  let mut builder = HdaResponseBuilder::new(200, "OK")
  builder = builder.swap(swap)
  if target.length() > 0 {
    builder = builder.target(target)
  }
  builder.html(html)
}

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
