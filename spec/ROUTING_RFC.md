# Typed Routing RFC (Draft)

Goal: define a minimal, type-safe routing surface for HDA/HATEOAS that avoids
stringly-typed paths, and can power LinkRel generation.

## Goals

- Typed path + query param decoding with explicit error types.
- Deterministic path encoding from typed params (round-trip friendly).
- Small API surface; easy to test; no external deps.
- Works with current `Route`/`LinkRel` style.

## Non-goals

- Full HTTP router (middlewares, nesting, wildcard routing).
- Automatic request body decoding.
- Framework-specific lifecycle.

## Design Overview

Provide a `RouteSpec[T]` that owns:
- HTTP verb (typed)
- A path template
- A decoder from raw params to typed `T`
- An encoder from typed `T` to a concrete path

This keeps compile-time type safety via `T` and avoids global route tables.

## Proposed Types (Sketch)

```mbt
pub(all) enum RouteError {
  MethodMismatch
  NotFound
  MissingParam(String)
  InvalidParam(String, String) // (name, value)
  InvalidQuery(String, String)
} derive(Show, Eq)

pub(all) struct PathParams {
  segments : @hashmap.HashMap[String, String]
}

pub(all) struct QueryParams {
  items : @hashmap.HashMap[String, String]
}

pub(all) struct RouteSpec[T] {
  method : RouteMethod
  template : String
  decode : (PathParams, QueryParams) -> Result[T, RouteError]
  encode : (T) -> String
}
```

## API Sketch

```mbt
pub fn RouteSpec::get[T](
  template : String,
  decode : (PathParams, QueryParams) -> Result[T, RouteError],
  encode : (T) -> String,
) -> RouteSpec[T]

pub fn RouteSpec::post[T](...) -> RouteSpec[T]

pub fn RouteSpec::match[T](
  spec : RouteSpec[T],
  method : Method,
  path : String,
  query : String,
) -> Result[T, RouteError]

pub fn PathParams::get(self : PathParams, key : String) -> String?
pub fn PathParams::get_int(self : PathParams, key : String) -> Result[Int, RouteError]
pub fn QueryParams::get(self : QueryParams, key : String) -> String?
```

## Example

```mbt
type UserRoute = { id : Int }

let user_route : RouteSpec[UserRoute] =
  RouteSpec::get(
    "/users/:id",
    decode=(path, _q) => {
      let id = path.get_int("id")?
      Ok({ id })
    },
    encode=(u) => "/users/" + u.id.to_string(),
  )

match RouteSpec::match(user_route, req.get_method(), req.path, req.query_raw) {
  Ok(params) => ...
  Err(RouteError::NotFound) => ...
  Err(_) => ...
}
```

## LinkRel Integration

```mbt
let link = @hda.LinkRel::new(
  @hda.Rel::Item,
  @router.Route::get(user_route.encode({ id: 1 })),
)
```

## Next Steps

- Decide path template syntax (e.g., `:id` vs `{id}`).
- Add round-trip tests for encode/decode.
- Decide if query params should support multi-values.
