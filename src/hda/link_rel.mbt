///|
/// Link relation builder for HDA hypermedia controls.
pub(all) struct LinkRel {
  rel : Rel
  route : @router.Route
  swap : @html.Swap?
  target : String?
}

///|
pub fn LinkRel::new(rel : Rel, route : @router.Route) -> LinkRel {
  { rel, route, swap: None, target: None }
}

///|
pub fn LinkRel::swap(self : LinkRel, s : @html.Swap) -> LinkRel {
  { ..self, swap: Some(s) }
}

///|
pub fn LinkRel::target(self : LinkRel, selector : String) -> LinkRel {
  { ..self, target: Some(selector) }
}

///|
fn attrs_for_route(route : @router.Route) -> @html.Attrs {
  let path = route.path()
  match route {
    @router.Route::Get(_) => @html.Attrs::new().hx_get(path)
    @router.Route::Post(_) => @html.Attrs::new().hx_post(path)
    @router.Route::Put(_) => @html.Attrs::new().hx_put(path)
    @router.Route::Delete(_) => @html.Attrs::new().hx_delete(path)
    @router.Route::Patch(_) => @html.Attrs::new().hx_patch(path)
  }
}

///|
fn LinkRel::to_attrs_inner(self : LinkRel, include_rel : Bool) -> @html.Attrs {
  let mut attrs = attrs_for_route(self.route)
  let rel_value = self.rel.to_string()
  if include_rel {
    attrs = attrs.add("rel", @html.AttrValue::Str(rel_value))
  }
  attrs = attrs.add("data-rel", @html.AttrValue::Str(rel_value))
  match self.swap {
    Some(s) => attrs = attrs.hx_swap_safe(s)
    None => ()
  }
  match self.target {
    Some(selector) => attrs = attrs.hx_target(selector)
    None => ()
  }
  attrs
}

///|
pub fn LinkRel::to_attrs(self : LinkRel) -> @html.Attrs {
  self.to_attrs_inner(false)
}

///|
pub fn LinkRel::to_link_attrs(self : LinkRel) -> @html.Attrs {
  self.to_attrs_inner(true)
}
