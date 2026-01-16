///|
/// Property-Based Tests for router package
/// Auto-generated from engenis.pbt.mbt.md

///|
test "prop_route_verb_matches_constructor" {
  let route_get = Route::get("/test")
  let route_post = Route::post("/test")
  let route_put = Route::put("/test")
  let route_delete = Route::delete("/test")
  let route_patch = Route::patch("/test")

  assert_eq(route_get.verb(), RouteMethod::Get)
  assert_eq(route_post.verb(), RouteMethod::Post)
  assert_eq(route_put.verb(), RouteMethod::Put)
  assert_eq(route_delete.verb(), RouteMethod::Delete)
  assert_eq(route_patch.verb(), RouteMethod::Patch)
}

///|
test "prop_pathparams_set_increases_size" {
  let empty = PathParams::new()
  let with_one = empty.set("key1", "value1")
  let with_two = with_one.set("key2", "value2")

  match with_one.get("key1") {
    Some(v) => assert_eq(v, "value1")
    None => assert_true(false, msg="key1 should exist")
  }

  match with_two.get("key2") {
    Some(v) => assert_eq(v, "value2")
    None => assert_true(false, msg="key2 should exist")
  }
}

///|
test "prop_pathparams_set_overwrites" {
  let params = PathParams::new()
  let with_v1 = params.set("key", "value1")
  let with_v2 = with_v1.set("key", "value2")

  match with_v2.get("key") {
    Some(v) => assert_eq(v, "value2", msg="should have new value")
    None => assert_true(false, msg="key should exist")
  }
}

///|
test "prop_pathparams_require_returns_value" {
  let params = PathParams::new().set("id", "123")
  assert_eq(params.require("id"), "123")
}
