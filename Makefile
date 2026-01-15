.PHONY: demo showcase counter test fmt info check

demo: showcase

showcase:
	moon run examples/showcase/cmd/main

counter:
	moon run examples/counter/cmd/main

test:
	moon test

fmt:
	moon fmt

info:
	moon info

check:
	moon check
