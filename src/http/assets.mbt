///|
/// Load a static asset into memory once at startup.
pub async fn load_asset_bytes(path : String) -> Bytes? {
  let exists = @async_fs.exists(path)
  if !exists {
    return None
  }
  let file = @async_fs.open(path, mode=@async_fs.Mode::ReadOnly)
  let size = file.size()
  let bytes = file.read_exactly(size.to_int())
  file.close()
  Some(bytes)
}
