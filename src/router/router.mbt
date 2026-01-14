///|
pub(all) struct PathParams {
  segments : @hashmap.HashMap[String, String]
} derive(Show)

///|
pub fn PathParams::new() -> PathParams {
  { segments: @hashmap.new() }
}

///|
pub fn PathParams::get(self : PathParams, key : String) -> String? {
  self.segments.get(key)
}

///|
pub fn PathParams::require(self : PathParams, key : String) -> String {
  match self.segments.get(key) {
    Some(value) => value
    None => @builtin.panic()
  }
}

///|
pub fn PathParams::set(
  self : PathParams,
  key : String,
  value : String,
) -> PathParams {
  let new_segments = self.segments.copy()
  new_segments.set(key, value)
  { segments: new_segments }
}
