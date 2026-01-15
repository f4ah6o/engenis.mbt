///|
fn get_attr_value(el : Element, name : String) -> String? {
  get_attr(el, name)
}

///|
pub fn hx_get(el : Element) -> String? {
  get_attr_value(el, "hx-get")
}

///|
pub fn hx_target(el : Element) -> String? {
  get_attr_value(el, "hx-target")
}

///|
pub fn hx_swap(el : Element) -> String? {
  get_attr_value(el, "hx-swap")
}
