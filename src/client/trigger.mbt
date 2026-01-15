///|
pub(all) enum TriggerMode {
  Event(String)
  Immediate
} derive(Show, Eq)

///|
fn first_segment(value : String, sep : String) -> String {
  let parts = value.split(sep).to_array()
  if parts.length() == 0 {
    ""
  } else {
    parts[0].to_string()
  }
}

///|
fn normalize_event(value : String) -> String? {
  let trimmed = value.trim().to_string()
  if trimmed.length() == 0 {
    return None
  }
  let comma = first_segment(trimmed, ",")
  let bracket = first_segment(comma, "[")
  let space = first_segment(bracket, " ")
  let event = space.trim().to_string()
  if event.length() == 0 {
    None
  } else {
    Some(event)
  }
}

///|
pub fn parse_trigger(value : String?) -> TriggerMode {
  match value {
    Some(raw) =>
      match normalize_event(raw) {
        Some("load") => Immediate
        Some(event) => Event(event)
        None => Event("click")
      }
    None => Event("click")
  }
}
