///|
/// カウンター状態
/// Note: 本来は @atomic などでスレッドセーフにする必要があります
/// 簡易実装としてミュータブル変数を使用
priv struct Counter {
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
/// メインページの HTML を構築（HTML DSL + HDA で型安全に構築）
fn render_home_page() -> String {
  let count = get_count()
  let inc_link = @hda.LinkRel::new(
      @hda.Rel::namespaced("counter", "inc"),
      @router.Route::post("/counter/inc"),
    )
    .target("#counter")
    .swap(@html.Swap::InnerHTML)
  let dec_link = @hda.LinkRel::new(
      @hda.Rel::namespaced("counter", "dec"),
      @router.Route::post("/counter/dec"),
    )
    .target("#counter")
    .swap(@html.Swap::InnerHTML)
  @html.fragment([
    @html.doctype(),
    @html.html()
    .attr("lang", @html.AttrValue::Str("en"))
    .children([
      @html.head().children([
        @html.meta().attr("charset", @html.AttrValue::Str("UTF-8")).empty(),
        @html.title().text("Engenis Counter"),
        // TEMPORARY: HTMX is used as a client-side dependency during development.
        // This will be replaced with a Pure MoonBit client runtime in the future.
        // See: spec/CLIENT_DEPENDENCY.md
        @html.script()
        .attr("src", @html.AttrValue::Str("https://unpkg.com/htmx.org@1.9.10"))
        .empty(),
      ]),
      @html.body()
      .attr(
        "style",
        @html.AttrValue::Str(
          "font-family: system-ui; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0;",
        ),
      )
      .children([
        @html.div()
        .attr("style", @html.AttrValue::Str("text-align: center;"))
        .children([
          @html.h1().text("Engenis Counter"),
          @html.p().text("Hypermedia Driven Application with MoonBit"),
          @html.div()
          .id("counter")
          .attr(
            "style",
            @html.AttrValue::Str("font-size: 48px; margin: 20px 0;"),
          )
          .text(count.to_string()),
          @html.div()
          .attr("style", @html.AttrValue::Str("gap: 10px; display: flex;"))
          .children([
            @html.button()
            .attrs(inc_link.to_attrs())
            .attr(
              "style",
              @html.AttrValue::Str(
                "font-size: 18px; padding: 10px 20px; cursor: pointer;",
              ),
            )
            .text("+"),
            @html.button()
            .attrs(dec_link.to_attrs())
            .attr(
              "style",
              @html.AttrValue::Str(
                "font-size: 18px; padding: 10px 20px; cursor: pointer;",
              ),
            )
            .text("-"),
          ]),
        ]),
      ]),
    ]),
  ]).render()
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
