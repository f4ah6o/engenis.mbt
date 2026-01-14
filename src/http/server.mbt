///|
/// ハンドラー型
pub type Handler = (Request) -> Response

///|
/// HTTPサーバー
pub(all) struct Server {
  inner_server : @async_http.Server
  handler_func : Handler
}

///|
/// アドレスからサーバーを作成
/// エラーが発生した場合、この関数はエラー型を返します
pub fn Server::new(
  addr : @async_socket.Addr,
  handler : Handler,
) -> Server raise {
  let inner_server = @async_http.Server::new(addr)
  { inner_server, handler_func: handler }
}

///|
/// 文字列からサーバーを作成（エイリアス）
pub fn Server::bind(addr_str : String, handler : Handler) -> Server raise {
  let addr = @async_socket.Addr::parse(addr_str)
  let inner_server = @async_http.Server::new(addr)
  { inner_server, handler_func: handler }
}

///|
/// サーバーを開始（非同期）
pub async fn Server::run(self : Server) -> Unit {
  self.inner_server.run_forever(
    fn(async_req, _reader, conn) {
      let req = Request::from_async(async_req)
      let handler = self.handler_func
      let resp = handler(req)
      send_response(conn, resp)
      ()
    },
    allow_failure=true,
  )
}

///|
/// Response を ServerConnection に送信
async fn send_response(
  conn : @async_http.ServerConnection,
  resp : Response,
) -> Unit {
  // ヘッダーを送信
  let headers_map = Map::from_array(resp.headers.to_array())
  conn.send_response(resp.status, resp.reason, extra_headers=headers_map)

  // ボディを送信
  match resp.body {
    ResponseBody::Empty => ()
    ResponseBody::Text(s) => {
      conn.write(s)
      ()
    }
    ResponseBody::Bytes(b) => {
      conn.write(b)
      ()
    }
  }
  conn.end_response()
}

///|
/// サーバーを開始して完了まで待機
pub async fn Server::run_forever(self : Server) -> Unit {
  self.run()
}

///|
/// サーバーのアドレスを取得
pub fn Server::addr(self : Server) -> @async_socket.Addr {
  self.inner_server.addr()
}

///|
/// サーバーを閉じる
pub fn Server::close(self : Server) -> Unit {
  self.inner_server.close()
}
