.DEFAULT_GOAL := help

PACKAGE := ic-metrics
MSRV ?= 1.88.0

.PHONY: help fmt fmt-check check check-wasm clippy docs-check test msrv shared-tooling-check ci

help:
	@echo "Focused: fmt, fmt-check, check, check-wasm, clippy, docs-check, msrv, shared-tooling-check"
	@echo "Named tests: cargo test -p $(PACKAGE) --locked <test-name>"
	@echo "Full gates (explicit request or configured CI): test, ci"

fmt:
	cargo fmt --all

fmt-check:
	cargo fmt --all --check

check:
	cargo check -p $(PACKAGE) --locked

check-wasm:
	cargo check -p $(PACKAGE) --locked --target wasm32-unknown-unknown

clippy:
	cargo clippy -p $(PACKAGE) --all-targets --locked -- -D warnings

docs-check:
	RUSTDOCFLAGS="-D warnings" cargo doc -p $(PACKAGE) --locked --no-deps

test:
	cargo test -p $(PACKAGE) --locked

msrv:
	cargo +$(MSRV) check -p $(PACKAGE) --locked
	cargo +$(MSRV) check -p $(PACKAGE) --locked --target wasm32-unknown-unknown

shared-tooling-check:
	bash scripts/ci/verify-shared-tooling-snapshot.sh

# Keep order explicit: stop on a failed gate, including any Clippy warning.
ci:
	+$(MAKE) --no-print-directory shared-tooling-check
	+$(MAKE) --no-print-directory fmt-check
	+$(MAKE) --no-print-directory check
	+$(MAKE) --no-print-directory check-wasm
	+$(MAKE) --no-print-directory clippy
	+$(MAKE) --no-print-directory docs-check
	+$(MAKE) --no-print-directory test
