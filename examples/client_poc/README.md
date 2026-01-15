# Client Runtime POC

This example bundles the `htmx.mbt` runtime:
- initializes `@htmx.htmx_init()`
- handles `hx-get` + `hx-target` + `hx-swap` interactions

## Build

```bash
make client-runtime
```

Or manually:

```bash
moon build --target js examples/client_poc/cmd/main
```

Copy the generated bundle to `examples/client_poc/app.js` and `assets/htmx.js`:

```bash
cp target/js/release/build/examples/client_poc/cmd/main/main.js examples/client_poc/app.js
cp target/js/release/build/examples/client_poc/cmd/main/main.js assets/htmx.js
```

If the output path changes, locate it with:

```bash
JS_OUT=$(rg --files -g '*.js' target/js | rg 'client_poc' | head -n 1)
cp "$JS_OUT" examples/client_poc/app.js
cp "$JS_OUT" assets/htmx.js
```

## Run

Serve the directory and open the page:

```bash
python3 -m http.server --directory examples/client_poc 8081
```

Then open `http://127.0.0.1:8081` and click the button.
