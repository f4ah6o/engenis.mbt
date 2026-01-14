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
pub fn Method::from_async(m : @async_http.RequestMethod) -> Method {
  match m {
    @async_http.RequestMethod::Get => Get
    @async_http.RequestMethod::Head => Head
    @async_http.RequestMethod::Post => Post
    @async_http.RequestMethod::Put => Put
    @async_http.RequestMethod::Delete => Delete
    @async_http.RequestMethod::Connect => Connect
    @async_http.RequestMethod::Options => Options
    @async_http.RequestMethod::Trace => Trace
    @async_http.RequestMethod::Patch => Patch
  }
}

///|
pub fn Method::to_async(self : Method) -> @async_http.RequestMethod {
  match self {
    Get => @async_http.RequestMethod::Get
    Head => @async_http.RequestMethod::Head
    Post => @async_http.RequestMethod::Post
    Put => @async_http.RequestMethod::Put
    Delete => @async_http.RequestMethod::Delete
    Connect => @async_http.RequestMethod::Connect
    Options => @async_http.RequestMethod::Options
    Trace => @async_http.RequestMethod::Trace
    Patch => @async_http.RequestMethod::Patch
  }
}

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
pub fn Request::from_async(r : @async_http.Request) -> Request {
  // 簡易実装 - クエリ文字列のパースは後で実装
  {
    mthd: Method::from_async(r.meth),
    path: r.path,
    query: @hashmap.new(),
    headers: @hashmap.new(),
    body: Bytes::new(0),
  }
}

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
