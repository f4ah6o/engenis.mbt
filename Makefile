.PHONY: demo showcase counter test fmt info check client-runtime

demo: showcase

showcase:
	moon run examples/showcase/cmd/main

counter:
	moon run examples/counter/cmd/main

client-runtime:
	moon build --target js examples/client_poc/cmd/main
	mkdir -p assets
	cp target/js/release/build/examples/client_poc/cmd/main/main.js assets/htmx.js
	cp target/js/release/build/examples/client_poc/cmd/main/main.js examples/client_poc/app.js

test:
	moon test

fmt:
	moon fmt

info:
	moon info

check:
	moon check
