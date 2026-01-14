///|
test "route path normalization" {
  let route = @router.Route::get("counter/inc")
  inspect(route.path(), content="/counter/inc")
  inspect(@router.Route::get("/").path(), content="/")
  inspect(@router.Route::get("").path(), content="/")
}

///|
test "route method mapping" {
  inspect(@router.Route::post("/counter/inc").verb(), content="Post")
  inspect(@router.Route::delete("/counter/dec").verb(), content="Delete")
}
