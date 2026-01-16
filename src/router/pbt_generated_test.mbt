///|
/// Property-Based Tests for router package
/// Auto-generated from router.pbt.md

///|
test "prop_pathparams_new_empty" {
  let params = PathParams::new()
  assert_eq(params.segments.length(), 0, msg="new params should be empty")
}

///|
test "prop_pathparams_set_increases_length" {
  let params1 = PathParams::new()
  assert_eq(params1.segments.length(), 0)
  let params2 = params1.set("key1", "value1")
  assert_eq(params2.segments.length(), 1)
  let params3 = params2.set("key2", "value2")
  assert_eq(params3.segments.length(), 2)
}

///|
test "prop_pathparams_get_retrieves_set" {
  let params = PathParams::new().set("id", "123").set("name", "test")
  match params.get("id") {
    Some(v) => assert_eq(v, "123")
    None => assert_true(false, msg="should find id")
  }
  match params.get("name") {
    Some(v) => assert_eq(v, "test")
    None => assert_true(false, msg="should find name")
  }
  match params.get("missing") {
    Some(_) => assert_true(false, msg="should not find missing")
    None => ()
  }
}

///|
test "prop_pathparams_set_updates_existing" {
  let params1 = PathParams::new().set("key", "value1")
  assert_eq(params1.segments.length(), 1)
  let params2 = params1.set("key", "value2")
  assert_eq(params2.segments.length(), 1)
  match params2.get("key") {
    Some(v) => assert_eq(v, "value2")
    None => assert_true(false, msg="should find updated key")
  }
}

///|
test "prop_route_verb_matches" {
  let get_route = Route::get("/test")
  assert_eq(get_route.verb(), RouteMethod::Get)
  let post_route = Route::post("/submit")
  assert_eq(post_route.verb(), RouteMethod::Post)
  let put_route = Route::put("/update")
  assert_eq(put_route.verb(), RouteMethod::Put)
  let delete_route = Route::delete("/remove")
  assert_eq(delete_route.verb(), RouteMethod::Delete)
  let patch_route = Route::patch("/modify")
  assert_eq(patch_route.verb(), RouteMethod::Patch)
}

///|
test "prop_route_path_preserved" {
  let path = "/users/:id/posts"
  let route = Route::get(path)
  assert_eq(route.path(), "/users/:id/posts")
}

///|
test "prop_path_normalization_adds_leading_slash" {
  let normalized1 = Route::get("test")
  assert_eq(normalized1.path(), "/test")
  let normalized2 = Route::get("/test")
  assert_eq(normalized2.path(), "/test")
  let normalized3 = Route::get("")
  assert_eq(normalized3.path(), "/")
}
