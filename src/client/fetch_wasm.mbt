///|
pub fn fetch_text(
  url : String,
  ok : (String) -> Unit,
  err : (String) -> Unit,
) -> Unit {
  ignore(url)
  ignore(ok)
  err("fetch is not available on native backend")
}
