///|
pub(all) struct Document {}

///|
pub(all) struct Element {}

///|
pub(all) struct Event {}

///|
pub fn get_document() -> Document? {
  None
}

///|
pub fn query_selector(doc : Document, selector : String) -> Element? {
  ignore(doc)
  ignore(selector)
  None
}

///|
pub fn query_selector_all(doc : Document, selector : String) -> Array[Element] {
  ignore(doc)
  ignore(selector)
  []
}

///|
pub fn get_attr(el : Element, name : String) -> String? {
  ignore(el)
  ignore(name)
  None
}

///|
pub fn set_inner_html(el : Element, html : String) -> Unit {
  ignore(el)
  ignore(html)
}

///|
pub fn set_outer_html(el : Element, html : String) -> Unit {
  ignore(el)
  ignore(html)
}

///|
pub fn add_event_listener(
  el : Element,
  name : String,
  cb : (Event) -> Unit,
) -> Unit {
  ignore(el)
  ignore(name)
  ignore(cb)
}

///|
pub fn prevent_default(ev : Event) -> Unit {
  ignore(ev)
}
