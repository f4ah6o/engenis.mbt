///|
/// ハンドラー型
pub type Handler = (Request) -> Response

/// HTTPサーバー
pub(all) struct Server {
  inner_server : @async_http.Server
  handler_func : Handler
}

/// アドレスからサーバーを作成
/// エラーが発生した場合、この関数はエラー型を返します
pub fn Server::new(addr : @async_socket.Addr, handler : Handler) -> Server raise {
  let inner_server = @async_http.Server::new(addr)
  { inner_server, handler_func: handler }
}

/// サーバーを開始（非同期）
pub async fn Server::run(self : Server) -> Unit {
  self.inner_server.run_forever(fn(async_req, _reader, _conn) {
    let req = Request::from_async(async_req)
    let handler = self.handler_func
    let _resp = handler(req)
    // TODO: レスポンスを送信する実装
    ()
  }, allow_failure = true)
}

/// サーバーを開始して完了まで待機
pub async fn Server::run_forever(self : Server) -> Unit {
  self.run()
}

/// サーバーのアドレスを取得
pub fn Server::addr(self : Server) -> @async_socket.Addr {
  self.inner_server.addr()
}

/// サーバーを閉じる
pub fn Server::close(self : Server) -> Unit {
  self.inner_server.close()
}
