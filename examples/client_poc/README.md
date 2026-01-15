# Client Runtime POC

This example validates a minimal client runtime:
- binds click events on `hx-get`
- fetches a fragment
- swaps `innerHTML` into a target

## Build

```bash
moon build --target js examples/client_poc/cmd/main
```

Copy the generated bundle to `examples/client_poc/app.js`:

```bash
cp target/js/release/build/examples/client_poc/cmd/main/main.js examples/client_poc/app.js
```

If the output path changes, locate it with:

```bash
JS_OUT=$(rg --files -g '*.js' target/js | rg 'client_poc' | head -n 1)
cp "$JS_OUT" examples/client_poc/app.js
```

## Run

Serve the directory and open the page:

```bash
python3 -m http.server --directory examples/client_poc 8081
```

Then open `http://127.0.0.1:8081` and click the button.
