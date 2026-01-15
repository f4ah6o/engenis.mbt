///|
#external
pub type Document

///|
#external
pub type Element

///|
#external
pub type Event

///|
extern "js" fn get_document() -> Document? =
  #| () => (typeof document !== "undefined" ? document : null)

///|
extern "js" fn query_selector(doc : Document, selector : String) -> Element? =
  #| (doc, selector) => doc.querySelector(selector)

///|
extern "js" fn query_selector_all(
  doc : Document,
  selector : String,
) -> Array[Element] =
  #| (doc, selector) => Array.from(doc.querySelectorAll(selector))

///|
extern "js" fn get_attr(el : Element, name : String) -> String? =
  #| (el, name) => el.getAttribute(name)

///|
extern "js" fn set_inner_html(el : Element, html : String) -> Unit =
  #| (el, html) => { el.innerHTML = html; }

///|
extern "js" fn set_outer_html(el : Element, html : String) -> Unit =
  #| (el, html) => { el.outerHTML = html; }

///|
extern "js" fn add_event_listener(
  el : Element,
  name : String,
  cb : (Event) -> Unit,
) -> Unit =
  #| (el, name, cb) => { el.addEventListener(name, (e) => cb(e)); }

///|
extern "js" fn prevent_default(ev : Event) -> Unit =
  #| (ev) => { ev.preventDefault(); }
