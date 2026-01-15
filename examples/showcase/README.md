# Showcase Demo

This demo highlights:
- type-safe HTML DSL
- typed LinkRel and HDA attributes
- server-driven swaps with HDA responses

## Run

```bash
make client-runtime
moon run examples/showcase/cmd/main
```

Open `http://127.0.0.1:8082` in your browser.

Note: this demo serves `assets/htmx.js` built from `htmx.mbt`.
