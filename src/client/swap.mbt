///|
fn swap_from_string(value : String) -> @html.Swap? {
  match value {
    "innerHTML" => Some(@html.Swap::InnerHTML)
    "outerHTML" => Some(@html.Swap::OuterHTML)
    "beforebegin" => Some(@html.Swap::BeforeBegin)
    "afterbegin" => Some(@html.Swap::AfterBegin)
    "beforeend" => Some(@html.Swap::BeforeEnd)
    "afterend" => Some(@html.Swap::AfterEnd)
    "delete" => Some(@html.Swap::Delete)
    "none" => Some(@html.Swap::None)
    _ => None
  }
}

///|
pub fn parse_swap(value : String?) -> @html.Swap {
  match value {
    Some(v) =>
      match swap_from_string(v) {
        Some(s) => s
        None => @html.Swap::InnerHTML
      }
    None => @html.Swap::InnerHTML
  }
}

///|
pub fn apply_swap(swap : @html.Swap, target : Element, html : String) -> Unit {
  match swap {
    @html.Swap::OuterHTML => set_outer_html(target, html)
    @html.Swap::InnerHTML => set_inner_html(target, html)
    // TODO: implement other swap strategies in the runtime.
    _ => set_inner_html(target, html)
  }
}
