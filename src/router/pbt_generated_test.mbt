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

///|
test "prop_normalize_path_empty_becomes_root" {
  let route = Route::get("")
  assert_eq(route.path(), "/", msg="empty path should normalize to /")
}

///|
test "prop_normalize_path_adds_leading_slash" {
  let route = Route::post("users")
  let path = route.path()
  assert_true(path.has_prefix("/"), msg="should have leading slash")
  assert_eq(path, "/users", msg="should be /users")
}

///|
test "prop_normalize_path_preserves_leading_slash" {
  let route = Route::put("/api/data")
  let path = route.path()
  assert_true(path.has_prefix("/"), msg="should have leading slash")
  assert_eq(path, "/api/data", msg="should preserve path with leading slash")
}

///|
test "prop_route_get_creates_get_variant" {
  let route = Route::get("/test")
  match route {
    Get(_) => ()
    _ => assert_true(false, msg="should be Get variant")
  }
}

///|
test "prop_route_post_creates_post_variant" {
  let route = Route::post("/submit")
  match route {
    Post(_) => ()
    _ => assert_true(false, msg="should be Post variant")
  }
}

///|
test "prop_route_put_creates_put_variant" {
  let route = Route::put("/update")
  match route {
    Put(_) => ()
    _ => assert_true(false, msg="should be Put variant")
  }
}

///|
test "prop_route_delete_creates_delete_variant" {
  let route = Route::delete("/remove")
  match route {
    Delete(_) => ()
    _ => assert_true(false, msg="should be Delete variant")
  }
}

///|
test "prop_route_patch_creates_patch_variant" {
  let route = Route::patch("/modify")
  match route {
    Patch(_) => ()
    _ => assert_true(false, msg="should be Patch variant")
  }
}

///|
test "prop_route_path_roundtrip" {
  let paths = ["/users", "/posts/:id", "/api/v1/data"]
  for i = 0; i < paths.length(); i = i + 1 {
    let original = paths[i]
    let route = Route::get(original)
    let retrieved = route.path()
    assert_eq(retrieved, original, msg="path should be preserved")
  }
}

///|
test "prop_route_path_normalized" {
  let path1 = Route::get("test").path()
  let path2 = Route::get("/test").path()
  assert_eq(path1, path2, msg="paths should normalize to same value")

  let path3 = Route::post("api").path()
  let path4 = Route::post("/api").path()
  assert_eq(path3, path4, msg="post paths should normalize")
}

///|
test "prop_route_verb_get_matches" {
  let route = Route::get("/test")
  let verb = route.verb()
  assert_eq(verb, RouteMethod::Get, msg="get route should have Get verb")
}

///|
test "prop_route_verb_post_matches" {
  let route = Route::post("/submit")
  let verb = route.verb()
  assert_eq(verb, RouteMethod::Post, msg="post route should have Post verb")
}

///|
test "prop_route_verb_put_matches" {
  let route = Route::put("/update")
  let verb = route.verb()
  assert_eq(verb, RouteMethod::Put, msg="put route should have Put verb")
}

///|
test "prop_route_verb_delete_matches" {
  let route = Route::delete("/remove")
  let verb = route.verb()
  assert_eq(verb, RouteMethod::Delete, msg="delete route should have Delete verb")
}

///|
test "prop_route_verb_patch_matches" {
  let route = Route::patch("/modify")
  let verb = route.verb()
  assert_eq(verb, RouteMethod::Patch, msg="patch route should have Patch verb")
}

///|
test "prop_pathparams_set_overwrites" {
  let params1 = PathParams::new().set("key", "value1")
  match params1.get("key") {
    Some(v) => assert_eq(v, "value1", msg="should have first value")
    None => assert_true(false, msg="should have value")
  }

  let params2 = params1.set("key", "value2")
  match params2.get("key") {
    Some(v) => assert_eq(v, "value2", msg="should have second value")
    None => assert_true(false, msg="should have updated value")
  }
}

///|
test "prop_pathparams_empty_key" {
  let params = PathParams::new().set("", "empty_key_value")
  match params.get("") {
    Some(v) => assert_eq(v, "empty_key_value", msg="should handle empty key")
    None => assert_true(false, msg="should find empty key")
  }
}

///|
test "prop_pathparams_special_characters" {
  let params = PathParams::new()
    .set("key-with-dash", "value-with-dash")
    .set("key_with_underscore", "value_with_underscore")
    .set("key.with.dot", "value.with.dot")

  match params.get("key-with-dash") {
    Some(v) => assert_eq(v, "value-with-dash", msg="should handle dash")
    None => assert_true(false, msg="should find dash key")
  }

  match params.get("key_with_underscore") {
    Some(v) => assert_eq(v, "value_with_underscore", msg="should handle underscore")
    None => assert_true(false, msg="should find underscore key")
  }

  match params.get("key.with.dot") {
    Some(v) => assert_eq(v, "value.with.dot", msg="should handle dot")
    None => assert_true(false, msg="should find dot key")
  }
}

///|
test "prop_pathparams_is_empty_true_for_new" {
  let params = PathParams::new()
  assert_true(params.is_empty(), msg="new params should be empty")
}

///|
test "prop_pathparams_is_empty_false_after_set" {
  let params = PathParams::new().set("key", "value")
  assert_true(!params.is_empty(), msg="params should not be empty after set")
}
