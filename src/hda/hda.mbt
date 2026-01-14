///|
/// HDA Swap戦略
pub(all) enum Swap {
  InnerHTML
  OuterHTML
  BeforeBegin
  AfterBegin
  BeforeEnd
  AfterEnd
  Delete
  None
} derive(Show, Eq)

pub fn Swap::to_string(self : Swap) -> String {
  match self {
    InnerHTML => "innerHTML"
    OuterHTML => "outerHTML"
    BeforeBegin => "beforebegin"
    AfterBegin => "afterbegin"
    BeforeEnd => "beforeend"
    AfterEnd => "afterend"
    Delete => "delete"
    None => "none"
  }
}

pub fn Swap::from_string(s : String) -> Swap? {
  match s {
    "innerHTML" => Some(InnerHTML)
    "outerHTML" => Some(OuterHTML)
    "beforebegin" => Some(BeforeBegin)
    "afterbegin" => Some(AfterBegin)
    "beforeend" => Some(BeforeEnd)
    "afterend" => Some(AfterEnd)
    "delete" => Some(Delete)
    "none" => Some(None)
    _ => None
  }
}

/// トリガー修飾子
pub(all) enum TriggerMod {
  Once
  Changed
  Delay(Int)
  Throttle(Int)
  From(String)
  Target(String)
  Filter(String)
  Consumed
  Queue(String)
} derive(Show, Eq)

pub fn TriggerMod::to_string(self : TriggerMod) -> String {
  match self {
    Once => "once"
    Changed => "changed"
    Delay(ms) => "delay:" + ms.to_string() + "ms"
    Throttle(ms) => "throttle:" + ms.to_string() + "ms"
    From(sel) => "from:" + sel
    Target(sel) => "target:" + sel
    Filter(expr) => "filter:" + expr
    Consumed => "consumed"
    Queue(name) => "queue:" + name
  }
}

/// トリガー
pub(all) enum Trigger {
  Event(String)
  EventWithMods(String, Array[TriggerMod])
  Multiple(Array[Trigger])
} derive(Show)

pub fn Trigger::to_string(self : Trigger) -> String {
  match self {
    Event(name) => name
    EventWithMods(name, mods) => {
      let mod_str = mods.map(TriggerMod::to_string).join(", ")
      if mod_str.length() > 0 {
        name + "[" + mod_str + "]"
      } else {
        name
      }
    }
    Multiple(triggers) => triggers.map(Trigger::to_string).join(", ")
  }
}

/// HDAレスポンスビルダー
pub(all) struct HdaResponseBuilder {
  status : Int
  reason : String
  headers : @hashmap.HashMap[String, String]
  body : String
}

pub fn HdaResponseBuilder::new(status : Int, reason : String) -> HdaResponseBuilder {
  let headers = @hashmap.from_array([("Content-Type", "text/html; charset=utf-8")])
  { status, reason, headers, body: "" }
}

pub fn HdaResponseBuilder::header(self : HdaResponseBuilder, key : String, value : String) -> HdaResponseBuilder {
  let new_headers = @hashmap.from_array([(key, value)])
  { status: self.status, reason: self.reason, headers: new_headers, body: self.body }
}

pub fn HdaResponseBuilder::swap(self : HdaResponseBuilder, s : Swap) -> HdaResponseBuilder {
  self.header("HX-Reswap", s.to_string())
}

pub fn HdaResponseBuilder::target(self : HdaResponseBuilder, selector : String) -> HdaResponseBuilder {
  self.header("HX-Retarget", selector)
}

pub fn HdaResponseBuilder::trigger(self : HdaResponseBuilder, event : String) -> HdaResponseBuilder {
  self.header("HX-Trigger", event)
}

pub fn HdaResponseBuilder::trigger_after_swap(self : HdaResponseBuilder, event : String) -> HdaResponseBuilder {
  self.header("HX-Trigger-After-Swap", event)
}

pub fn HdaResponseBuilder::trigger_after_settle(self : HdaResponseBuilder, event : String) -> HdaResponseBuilder {
  self.header("HX-Trigger-After-Settle", event)
}

pub fn HdaResponseBuilder::push_url(self : HdaResponseBuilder, url : String) -> HdaResponseBuilder {
  self.header("HX-Push-Url", url)
}

pub fn HdaResponseBuilder::redirect(self : HdaResponseBuilder, url : String) -> HdaResponseBuilder {
  self.header("HX-Redirect", url)
}

pub fn HdaResponseBuilder::replace_url(self : HdaResponseBuilder, url : String) -> HdaResponseBuilder {
  self.header("HX-Replace-Url", url)
}

pub fn HdaResponseBuilder::reswap(self : HdaResponseBuilder, s : Swap) -> HdaResponseBuilder {
  self.swap(s)
}

pub fn HdaResponseBuilder::html(self : HdaResponseBuilder, content : String) -> HdaResponseBuilder {
  { status: self.status, reason: self.reason, headers: self.headers, body: content }
}

pub fn HdaResponseBuilder::build(self : HdaResponseBuilder) -> @http.Response {
  {
    status: self.status,
    reason: self.reason,
    headers: self.headers,
    body: @http.ResponseBody::Text(self.body)
  }
}

/// HTMLレスポンスを作成
pub fn html_response(html : String) -> HdaResponseBuilder {
  HdaResponseBuilder::new(200, "OK").html(html)
}

/// HDAレスポンスを作成
pub fn hda_response(
  html : String,
  swap? : Swap = InnerHTML,
  target? : String = ""
) -> HdaResponseBuilder {
  let mut builder = HdaResponseBuilder::new(200, "OK")
  builder = builder.swap(swap)
  if target.length() > 0 {
    builder = builder.target(target)
  }
  builder.html(html)
}

/// HDA属性ビルダー（簡易実装）
pub(all) struct HdaAttrs {
  // 簡易実装 - 文字列で属性を保持
  attrs : @hashmap.HashMap[String, String]
}

pub fn HdaAttrs::new() -> HdaAttrs {
  { attrs: @hashmap.new() }
}

pub fn HdaAttrs::get(self : HdaAttrs, url : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-get", url)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::post(self : HdaAttrs, url : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-post", url)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::put(self : HdaAttrs, url : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-put", url)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::delete(self : HdaAttrs, url : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-delete", url)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::patch(self : HdaAttrs, url : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-patch", url)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::swap(self : HdaAttrs, s : Swap) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-swap", s.to_string())])
  { attrs: new_attrs }
}

pub fn HdaAttrs::target(self : HdaAttrs, selector : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-target", selector)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::trigger(self : HdaAttrs, t : Trigger) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-trigger", t.to_string())])
  { attrs: new_attrs }
}

pub fn HdaAttrs::on(self : HdaAttrs, event : String) -> HdaAttrs {
  self.trigger(Trigger::Event(event))
}

pub fn HdaAttrs::push_url(self : HdaAttrs, url : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-push-url", url)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::confirm(self : HdaAttrs, message : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-confirm", message)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::disable(self : HdaAttrs) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-disable", "true")])
  { attrs: new_attrs }
}

pub fn HdaAttrs::encoding(self : HdaAttrs, encoding : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-encoding", encoding)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::headers(self : HdaAttrs, headers : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-headers", headers)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::params(self : HdaAttrs, params : String) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-vals", params)])
  { attrs: new_attrs }
}

pub fn HdaAttrs::boost(self : HdaAttrs) -> HdaAttrs {
  let new_attrs = @hashmap.from_array([("hx-boost", "true")])
  { attrs: new_attrs }
}
