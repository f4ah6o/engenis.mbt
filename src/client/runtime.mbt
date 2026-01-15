///|
fn resolve_target(doc : Document, el : Element, selector : String?) -> Element? {
  match selector {
    Some(sel) => query_selector(doc, sel)
    None => Some(el)
  }
}

///|
fn run_fetch(
  doc : Document,
  el : Element,
  target_sel : String?,
  swap : @html.Swap,
  url : String,
) -> Unit {
  match resolve_target(doc, el, target_sel) {
    Some(target) =>
      fetch_text(url, fn(body) { apply_swap(swap, target, body) }, fn(msg) {
        println("fetch failed: " + msg)
      })
    None => ()
  }
}

///|
fn bind_hx_get(doc : Document, el : Element) -> Unit {
  match hx_get(el) {
    None => ()
    Some(url) => {
      let target_sel = hx_target(el)
      let swap = parse_swap(hx_swap(el))
      match parse_trigger(hx_trigger(el)) {
        Immediate => run_fetch(doc, el, target_sel, swap, url)
        Event(event) =>
          add_event_listener(el, event, fn(ev) {
            prevent_default(ev)
            run_fetch(doc, el, target_sel, swap, url)
          })
      }
    }
  }
}

///|
fn bind_hx_get_all(doc : Document) -> Unit {
  let elements = query_selector_all(doc, "[hx-get]")
  for i = 0; i < elements.length(); i = i + 1 {
    bind_hx_get(doc, elements[i])
  }
}

///|
/// Start the minimal client runtime.
pub fn start() -> Unit {
  match get_document() {
    Some(doc) => bind_hx_get_all(doc)
    None => ()
  }
}
