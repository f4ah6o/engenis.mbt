///|
extern "js" fn fetch_text(
  url : String,
  ok : (String) -> Unit,
  err : (String) -> Unit,
) -> Unit =
  #| (url, ok, err) => {
  #|   if (typeof fetch !== "function") {
  #|     err("fetch is not available");
  #|     return;
  #|   }
  #|   fetch(url)
  #|     .then((r) => r.text())
  #|     .then((text) => ok(text))
  #|     .catch((e) => err(String(e)));
  #| }
