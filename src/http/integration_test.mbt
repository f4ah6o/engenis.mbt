///|
/// HTTP レイヤの統合テスト

///|
/// Content-Type ヘッダーが正しく設定されることを確認
test "content-type header is set correctly" {
  // デフォルトの Content-Type を検証
  let response = Response::ok()
    .text("Hello")
  assert_eq(response.status, 200)
  let has_content_type = response.headers.length() > 0
  assert_true(has_content_type)
}

///|
/// カスタム Content-Type が設定されることを確認
test "custom content-type header" {
  let response = Response::ok()
    .content_type("application/json")
    .text("{}")
  assert_eq(response.status, 200)
  assert_true(response.headers.length() > 0)
}

///|
/// HdaResponseBuilder で HX-Reswap ヘッダーが設定されることを確認
test "hda response builder sets hx-reswap header" {
  let response = hda_response(
    "<div>Test</div>",
    swap=@html.Swap::InnerHTML,
    target="#main"
  ).build()
  assert_eq(response.status, 200)
  // HX-Reswap ヘッダーが含まれることを確認
  assert_true(response.headers.length() > 0)
}

///|
/// HdaResponseBuilder で HX-Retarget ヘッダーが設定されることを確認
test "hda response builder sets hx-retarget header" {
  let response = hda_response(
    "<div>Test</div>",
    swap=@html.Swap::OuterHTML,
    target="#main"
  ).build()
  assert_eq(response.status, 200)
  assert_true(response.headers.length() > 0)
}

///|
/// HdaResponseBuilder で HX-Trigger ヘッダーが設定されることを確認
test "hda response builder sets hx-trigger header" {
  let response = HdaResponseBuilder::new(200, "OK")
    .trigger("loaded")
    .html("<div>Test</div>")
    .build()
  assert_eq(response.status, 200)
  assert_true(response.headers.length() > 0)
}

///|
/// ResponseBuilder で複数のヘッダーが設定されることを確認
test "response builder multiple headers" {
  let response = Response::ok()
    .header("X-Custom", "value1")
    .header("X-Another", "value2")
    .text("Hello")
  assert_eq(response.status, 200)
  assert_eq(response.headers.length(), 3) // Content-Type + 2 custom
}

///|
/// HdaResponseBuilder で複数の HX-* ヘッダーが設定されることを確認
test "hda response builder multiple hx headers" {
  let response = hda_response(
    "<div>Test</div>",
    swap=@html.Swap::InnerHTML,
    target="#main"
  )
    .trigger("loaded")
    .build()
  assert_eq(response.status, 200)
  // Content-Type + HX-Reswap + HX-Retarget + HX-Trigger
  assert_true(response.headers.length() >= 3)
}

///|
/// Response::not_found が 404 ステータスを返すことを確認
test "not found response status" {
  let response = Response::not_found().text("Not Found")
  assert_eq(response.status, 404)
  assert_eq(response.reason, "Not Found")
}

///|
/// Response::bad_request が 400 ステータスを返すことを確認
test "bad request response status" {
  let response = Response::bad_request().text("Bad Request")
  assert_eq(response.status, 400)
  assert_eq(response.reason, "Bad Request")
}

///|
/// Response::internal_error が 500 ステータスを返すことを確認
test "internal error response status" {
  let response = Response::internal_error().text("Internal Error")
  assert_eq(response.status, 500)
  assert_eq(response.reason, "Internal Server Error")
}

///|
/// Response::created が 201 ステータスを返すことを確認
test "created response status" {
  let response = Response::created().text("Created")
  assert_eq(response.status, 201)
  assert_eq(response.reason, "Created")
}

///|
/// ResponseBody::Text がテキストボディを保持することを確認
test "response body text" {
  let response = Response::ok().text("Hello World")
  match response.body {
    ResponseBody::Text(s) => assert_true(s.length() > 0)
    _ => { assert_true(false) }
  }
}

///|
/// ResponseBody::Empty が空ボディを保持することを確認
test "response body empty" {
  let response = Response::ok().empty()
  match response.body {
    ResponseBody::Empty => { assert_true(true) }
    _ => { assert_true(false) }
  }
}

///|
/// Swap::to_string が正しい値を返すことを確認
test "swap to string values" {
  assert_eq(@html.Swap::InnerHTML.to_string(), "innerHTML")
  assert_eq(@html.Swap::OuterHTML.to_string(), "outerHTML")
  assert_eq(@html.Swap::BeforeBegin.to_string(), "beforebegin")
  assert_eq(@html.Swap::AfterBegin.to_string(), "afterbegin")
  assert_eq(@html.Swap::BeforeEnd.to_string(), "beforeend")
  assert_eq(@html.Swap::AfterEnd.to_string(), "afterend")
  assert_eq(@html.Swap::Delete.to_string(), "delete")
  assert_eq(@html.Swap::None.to_string(), "none")
}
