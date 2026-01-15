///|
/// HTTPメソッド
pub(all) enum Method {
  Get
  Head
  Post
  Put
  Delete
  Connect
  Options
  Trace
  Patch
} derive(Show, Eq, Compare, Hash, ToJson)

///|
/// HTTPリクエスト
pub(all) struct Request {
  mthd : Method
  path : String
  query : @hashmap.HashMap[String, String]
  headers : @hashmap.HashMap[String, String]
  body : Bytes
} derive(Show)

///|
/// リクエストのHTTPメソッドを取得
pub fn Request::get_method(self : Request) -> Method {
  self.mthd
}

///|
/// HTTPレスポンス
pub(all) enum ResponseBody {
  Empty
  Text(String)
  Bytes(Bytes)
} derive(Show)

///|
pub(all) struct Response {
  status : Int
  reason : String
  headers : @hashmap.HashMap[String, String]
  body : ResponseBody
} derive(Show)

///|
pub fn Response::ok() -> ResponseBuilder {
  ResponseBuilder::new(200, "OK")
}

///|
pub fn Response::created() -> ResponseBuilder {
  ResponseBuilder::new(201, "Created")
}

///|
pub fn Response::not_found() -> ResponseBuilder {
  ResponseBuilder::new(404, "Not Found")
}

///|
pub fn Response::bad_request() -> ResponseBuilder {
  ResponseBuilder::new(400, "Bad Request")
}

///|
pub fn Response::internal_error() -> ResponseBuilder {
  ResponseBuilder::new(500, "Internal Server Error")
}

///|
pub(all) struct ResponseBuilder {
  status : Int
  reason : String
  headers : @hashmap.HashMap[String, String]
}

///|
pub fn ResponseBuilder::new(status : Int, reason : String) -> ResponseBuilder {
  let headers = @hashmap.from_array([
    ("Content-Type", "text/plain; charset=utf-8"),
  ])
  { status, reason, headers }
}

///|
pub fn ResponseBuilder::header(
  self : ResponseBuilder,
  key : String,
  value : String,
) -> ResponseBuilder {
  let new_headers = self.headers.copy()
  new_headers.set(key, value)
  { status: self.status, reason: self.reason, headers: new_headers }
}

///|
pub fn ResponseBuilder::content_type(
  self : ResponseBuilder,
  ct : String,
) -> ResponseBuilder {
  self.header("Content-Type", ct)
}

///|
pub fn ResponseBuilder::text(self : ResponseBuilder, t : String) -> Response {
  {
    status: self.status,
    reason: self.reason,
    headers: self.headers,
    body: ResponseBody::Text(t),
  }
}

///|
pub fn ResponseBuilder::bytes(self : ResponseBuilder, data : Bytes) -> Response {
  {
    status: self.status,
    reason: self.reason,
    headers: self.headers,
    body: ResponseBody::Bytes(data),
  }
}

///|
pub fn ResponseBuilder::empty(self : ResponseBuilder) -> Response {
  {
    status: self.status,
    reason: self.reason,
    headers: self.headers,
    body: ResponseBody::Empty,
  }
}

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
pub fn HdaResponseBuilder::build(self : HdaResponseBuilder) -> Response {
  {
    status: self.status,
    reason: self.reason,
    headers: self.headers,
    body: ResponseBody::Text(self.body),
  }
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
