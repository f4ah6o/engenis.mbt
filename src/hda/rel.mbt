///|
/// Link relation identifiers for hypermedia controls.
pub(all) enum Rel {
  SelfRel
  Next
  Prev
  First
  Last
  Collection
  Item
  Related
  Search
  Edit
  Create
  Update
  Delete
  Help
  Profile
  Custom(String)
} derive(Show, Eq)

///|
pub fn Rel::custom(value : String) -> Rel {
  Custom(value)
}

///|
pub fn Rel::namespaced(ns : String, name : String) -> Rel {
  Custom(ns + ":" + name)
}

///|
pub fn Rel::to_string(self : Rel) -> String {
  match self {
    SelfRel => "self"
    Next => "next"
    Prev => "prev"
    First => "first"
    Last => "last"
    Collection => "collection"
    Item => "item"
    Related => "related"
    Search => "search"
    Edit => "edit"
    Create => "create"
    Update => "update"
    Delete => "delete"
    Help => "help"
    Profile => "profile"
    Custom(value) => value
  }
}
