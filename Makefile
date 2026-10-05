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
	+CARGO_NET_OFFLINE=true $(MAKE) --no-print-directory ci
	+CARGO_NET_OFFLINE=true $(MAKE) --no-print-directory msrv

release-prepare-version:
	@bash scripts/release/metadata.sh prepare

release-prepared-check release-commit-check release-committed-check release-tagged-check release-push-check:
	@bash scripts/release/metadata.sh check

release-files:
	@printf '%s\0' Cargo.toml Cargo.lock CHANGELOG.md

.PHONY: help install-hooks hook-check fmt fmt-check check check-wasm clippy docs-check test msrv shared-tooling-check release-tools-check ci

help:
	@echo "Maintainer releases: release-patch, release-minor, release-major; release-resume VERSION=X.Y.Z"
	@echo "Recovery: rerun the same release target to reconcile the saved candidate"
	@echo "Clone setup: install-hooks (requires prepared cargo-sort 2.1.4 and rustfmt)"
	@echo "Focused: fmt, fmt-check, check, check-wasm, clippy, docs-check, msrv, shared-tooling-check"
	@echo "Tooling fixtures: hook-check, release-tools-check (no release Git effects)"
	@echo "Named tests: cargo test -p $(PACKAGE) --locked <test-name>"
	@echo "Full gates (explicit request or configured CI): test, ci"

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

release-tools-check:
	bash scripts/ci/test-release-runner.sh
	bash scripts/release/test-standard-release.sh
	bash scripts/release/test-metadata.sh

# Keep order explicit: stop on a failed gate, including any Clippy warning.
ci:
	+$(MAKE) --no-print-directory shared-tooling-check
	+$(MAKE) --no-print-directory release-tools-check
	+$(MAKE) --no-print-directory hook-check
	+$(MAKE) --no-print-directory fmt-check
	+$(MAKE) --no-print-directory check
	+$(MAKE) --no-print-directory check-wasm
	+$(MAKE) --no-print-directory clippy
	+$(MAKE) --no-print-directory docs-check
	+$(MAKE) --no-print-directory test
