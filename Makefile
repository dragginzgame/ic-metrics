.DEFAULT_GOAL := help

PACKAGE := ic-metrics
MSRV ?= 1.88.0
RELEASE_REMOTE ?= origin
RELEASE_BRANCH ?= main

ifneq ($(word 2,$(filter release-patch release-minor release-major release-resume,$(MAKECMDGOALS))),)
$(error Select exactly one release target)
endif

.PHONY: release-patch release-minor release-major release-resume release-version release-preflight release-verify release-prepare-version release-prepared-check release-files release-commit-check release-committed-check release-tagged-check release-push-check

release-patch release-minor release-major:
	+@bash scripts/ci/run-release.sh "$(@:release-%=%)" "$(RELEASE_REMOTE)" "$(RELEASE_BRANCH)"

release-resume:
	+@bash scripts/ci/run-release.sh resume "$(VERSION)" "$(RELEASE_REMOTE)" "$(RELEASE_BRANCH)"

release-version:
	@bash scripts/release/metadata.sh version

release-preflight:
	@bash scripts/release/metadata.sh preflight

release-verify:
	+CARGO_NET_OFFLINE=true VALIDATION_FAILURE_LOG_DIR="$$(git rev-parse --git-path release-state)/validation-failures" \
		bash scripts/ci/run-validation-targets.sh --fail-fast ci msrv

release-prepare-version:
	@bash scripts/release/metadata.sh prepare

release-commit-check:
	@bash scripts/release/metadata.sh commit-check

release-prepared-check release-committed-check release-tagged-check release-push-check:
	@bash scripts/release/metadata.sh check

release-files:
	@printf '%s\0' Cargo.toml Cargo.lock CHANGELOG.md

.PHONY: help publish publish-check install-hooks hook-check fmt fmt-check check check-wasm clippy docs-check reader-check test msrv shared-tooling-check check-pins pin-tools-check release-tools-check ci

help:
	@echo "Maintainer releases: release-patch, release-minor, release-major; release-resume VERSION=X.Y.Z"
	@echo "Recovery: normal targets reconcile saved releases before validating a requested next increment"
	@echo "Registry: publish-check (dry run), publish (upload ic-metrics to crates.io)"
	@echo "Clone setup: install-hooks (requires prepared cargo-sort 2.1.4 and rustfmt)"
	@echo "Focused: fmt, fmt-check, check, check-wasm, clippy, docs-check, msrv, shared-tooling-check, check-pins"
	@echo "Tooling fixtures: hook-check, release-tools-check, pin-tools-check (no release Git effects)"
	@echo "Named tests: cargo test -p $(PACKAGE) --locked <test-name>"
	@echo "IC reader: reader-check POCKET_IC_BIN=/absolute/path/to/pocket-ic (pinned 16.0.0)"
	@echo "Full gates (explicit request or configured CI): test, ci"

publish:
	cargo publish -p $(PACKAGE) --locked --registry crates-io

publish-check:
	cargo publish -p $(PACKAGE) --locked --registry crates-io --dry-run

install-hooks:
	bash scripts/dev/install-git-hooks.sh

hook-check:
	bash scripts/dev/test-format-hook.sh

fmt:
	cargo sort --workspace
	cargo fmt --all

fmt-check:
	cargo sort --workspace --check
	cargo fmt --all -- --check

check:
	cargo check -p $(PACKAGE) --locked

check-wasm:
	cargo check -p $(PACKAGE) --locked --target wasm32-unknown-unknown
	cargo check -p $(PACKAGE) --locked --target wasm32-unknown-unknown --features ic

clippy:
	cargo clippy -p $(PACKAGE) --all-targets --locked -- -D warnings
	cargo clippy -p $(PACKAGE) --lib --example ic_reader_canister --locked --target wasm32-unknown-unknown --features ic -- -D warnings

docs-check:
	RUSTDOCFLAGS="-D warnings" cargo doc -p $(PACKAGE) --locked --no-deps
	RUSTDOCFLAGS="-D warnings" cargo doc -p $(PACKAGE) --locked --no-deps --target wasm32-unknown-unknown --features ic

reader-check:
	@test -n "$(POCKET_IC_BIN)" || { echo "Set POCKET_IC_BIN to a verified PocketIC 16.0.0 binary" >&2; exit 2; }
	CARGO_TARGET_DIR="$(CURDIR)/target" cargo build -p $(PACKAGE) --example ic_reader_canister --target wasm32-unknown-unknown --features ic --release --locked --offline
	CARGO_TARGET_DIR="$(CURDIR)/target" POCKET_IC_BIN="$(POCKET_IC_BIN)" IC_METRICS_READER_WASM="$(CURDIR)/target/wasm32-unknown-unknown/release/examples/ic_reader_canister.wasm" cargo test -p $(PACKAGE) --test ic_reader --locked --offline call_context_reader_matches_ic_and_survives_callback -- --exact --ignored --nocapture

test:
	cargo test -p $(PACKAGE) --locked

msrv:
	cargo +$(MSRV) check -p $(PACKAGE) --locked
	cargo +$(MSRV) check -p $(PACKAGE) --locked --target wasm32-unknown-unknown
	cargo +$(MSRV) check -p $(PACKAGE) --locked --target wasm32-unknown-unknown --features ic

shared-tooling-check:
	bash scripts/ci/verify-shared-tooling-snapshot.sh

check-pins:
	bash scripts/ci/check-dependency-pins.sh

pin-tools-check:
	bash scripts/ci/test-dependency-pins.sh

release-tools-check:
	bash scripts/ci/test-release-runner.sh
	bash scripts/release/test-standard-release.sh
	bash scripts/release/test-metadata.sh
	bash scripts/release/test-release-admission.sh

# Keep order explicit: stop on a failed gate, including any Clippy warning.
ci:
	+$(MAKE) --no-print-directory shared-tooling-check
	+$(MAKE) --no-print-directory check-pins
	+$(MAKE) --no-print-directory pin-tools-check
	+$(MAKE) --no-print-directory release-tools-check
	+$(MAKE) --no-print-directory hook-check
	+$(MAKE) --no-print-directory fmt-check
	+$(MAKE) --no-print-directory check
	+$(MAKE) --no-print-directory check-wasm
	+$(MAKE) --no-print-directory clippy
	+$(MAKE) --no-print-directory docs-check
	+$(MAKE) --no-print-directory test
