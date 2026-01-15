///|
/// Async HTTP bridge (native-only)
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
