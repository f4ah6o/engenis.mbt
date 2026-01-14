///|
/// カウンター状態
/// Note: 本来は @atomic などでスレッドセーフにする必要があります
/// 簡易実装としてミュータブル変数を使用
struct Counter {
  mut value : Int
}

///|
let counter : Counter = { value: 0 }

///|
/// カウンターをインクリメント
fn increment() -> Int {
  counter.value = counter.value + 1
  counter.value
}

///|
/// カウンターをデクリメント
fn decrement() -> Int {
  counter.value = counter.value - 1
  counter.value
}

///|
/// カウンターを取得
fn get_count() -> Int {
  counter.value
}

///|
/// メインページの HTML を構築
fn render_home_page() -> String {
  let count = get_count()
  let count_str = count.to_string()
  let part1 = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title>Engenis Counter</title><script src=\"https://unpkg.com/htmx.org@1.9.10\"></script></head><body style=\"font-family: system-ui; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0;\"><div style=\"text-align: center;\"><h1>Engenis Counter</h1><p>Hypermedia Driven Application with MoonBit</p><div id=\"counter\" style=\"font-size: 48px; margin: 20px 0;\">"
  let part2 = "</div><div style=\"gap: 10px; display: flex;\"><button hx-post=\"/counter/inc\" hx-target=\"#counter\" hx-swap=\"innerHTML\" style=\"font-size: 18px; padding: 10px 20px; cursor: pointer;\">+</button><button hx-post=\"/counter/dec\" hx-target=\"#counter\" hx-swap=\"innerHTML\" style=\"font-size: 18px; padding: 10px 20px; cursor: pointer;\">-</button></div></div></body></html>"
  part1 + count_str + part2
}

///|
/// カウンター値のみの HTML フラグメントを構築
fn render_counter_value() -> String {
  let count = get_count()
  count.to_string()
}

///|
/// ハンドラー関数
fn handler(req : Request) -> Response {
  match (req.mthd, req.path) {
    (_, "/") =>
      Response::ok()
      .content_type("text/html; charset=utf-8")
      .text(render_home_page())
    (_, "/counter/inc") => {
      let _new_count : Int = increment()
      hda_response(
        render_counter_value(),
        swap=@html.Swap::InnerHTML,
        target="#counter",
      ).build()
    }
    (_, "/counter/dec") => {
      let _new_count2 : Int = decrement()
      hda_response(
        render_counter_value(),
        swap=@html.Swap::InnerHTML,
        target="#counter",
      ).build()
    }
    (_, _) => Response::not_found().text("404 - Not Found")
  }
}

///|
/// カウンターサーバーを起動
pub async fn start_counter_server() -> Unit {
  let server = Server::bind("127.0.0.1:8080", handler) catch {
    _err => {
      println("Failed to create server")
      return
    }
  }
  println("========================================")
  println("  Engenis Counter Server")
  println("========================================")
  println("")
  println("Server running at http://127.0.0.1:8080")
  println("Press Ctrl+C to stop")
  println("")
  server.run_forever()
}
