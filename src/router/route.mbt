///|
/// Typed routes for hypermedia controls.
pub(all) enum Route {
  Get(String)
  Post(String)
  Put(String)
  Delete(String)
  Patch(String)
} derive(Show, Eq)

///|
pub(all) enum RouteMethod {
  Get
  Post
  Put
  Delete
  Patch
} derive(Show, Eq)

///|
fn normalize_path(path : String) -> String {
  if path.length() == 0 {
    "/"
  } else if path[0] == '/' {
    path
  } else {
    "/" + path
  }
}

///|
pub fn Route::get(path : String) -> Route {
  Get(normalize_path(path))
}

///|
pub fn Route::post(path : String) -> Route {
  Post(normalize_path(path))
}

///|
pub fn Route::put(path : String) -> Route {
  Put(normalize_path(path))
}

///|
pub fn Route::delete(path : String) -> Route {
  Delete(normalize_path(path))
}

///|
pub fn Route::patch(path : String) -> Route {
  Patch(normalize_path(path))
}

///|
pub fn Route::path(self : Route) -> String {
  match self {
    Get(path) => normalize_path(path)
    Post(path) => normalize_path(path)
    Put(path) => normalize_path(path)
    Delete(path) => normalize_path(path)
    Patch(path) => normalize_path(path)
  }
}

///|
pub fn Route::verb(self : Route) -> RouteMethod {
  match self {
    Get(_) => RouteMethod::Get
    Post(_) => RouteMethod::Post
    Put(_) => RouteMethod::Put
    Delete(_) => RouteMethod::Delete
    Patch(_) => RouteMethod::Patch
  }
}
