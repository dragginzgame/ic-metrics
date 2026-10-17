.DEFAULT_GOAL := help

PACKAGE := ic-metrics
export MSRV
export RELEASE_DELIVERY ?= direct
override RELEASE_DELIVERY_POLICY := $(CURDIR)/ci/release-delivery.txt
export YQ := $(CURDIR)/.tools/host/bin/yq

# Common commands use this checkout's reviewed snapshot, including scratch exports.
override SHARED_TOOLING_ROOT := $(CURDIR)
export SHARED_TOOLING_ROOT
include make/consumer.mk

.PHONY: $(SHARED_RELEASE_TARGETS)

release-patch release-minor release-major release-resume: export IC_METRICS_RELEASE_CACHE_PREPARE := 1

release-version:
	@bash scripts/release/metadata.sh version

release-preflight:
	+@RUST_TOOL_VERSIONS="$(RUST_TOOL_VERSIONS)" bash scripts/release/metadata.sh preflight

release-verify:
	+env -u IC_METRICS_RELEASE_CACHE_PREPARE CARGO_NET_OFFLINE=true VALIDATION_FAILURE_LOG_DIR="$$(git rev-parse --git-path release-state)/validation-failures" \
		bash scripts/ci/run-validation-targets.sh --fail-fast --input Cargo.toml --input Cargo.lock ci msrv

release-prepare-version:
	+@bash scripts/release/metadata.sh prepare

release-commit-check:
	+@bash scripts/release/metadata.sh commit-check

release-prepared-check release-committed-check release-tagged-check release-push-check:
	+@bash scripts/release/metadata.sh check

release-files:
	@bash scripts/release/metadata.sh files

.PHONY: help publish publish-check install-hooks hook-check check check-wasm clippy docs-check check-doc-links test msrv shared-tooling-check check-pins release-tools-check ci
.PHONY: ci-evidence-check

help:
	@echo "Local setup: install-tools; offline verification: tools-check"
	@echo "Reports: cloc (this workspace); fleet reports run in Shared Tooling"
	@echo "Maintainer releases: release-patch, release-minor, release-major; release-resume VERSION=X.Y.Z"
	@echo "Recovery: normal targets reconcile saved releases before validating a requested next increment"
	@echo "Registry: publish-check (dry run), publish (upload arithmetic and stable adapter to crates.io)"
	@echo "Rust setup: install-rust-tools; offline verification: rust-tools-check"
	@echo "Clone setup: install-hooks (requires prepared manifest formatter and rustfmt)"
	@echo "Focused: format-tools-check, fmt, fmt-check, check, check-wasm, clippy, docs-check, check-doc-links, msrv, shared-tooling-check, check-pins"
	@echo "Tooling fixtures: hook-check, release-tools-check (no release Git effects)"
	@echo "CI evidence fixture: ci-evidence-check (substitute action results and Make effects, no hosted run)"
	@echo "Named tests: cargo test -p $(PACKAGE) --locked <test-name>"
	@echo "Maintenance task definitions: tasks/README.md (adoption does not activate a schedule)"
	@echo "Workspace gates cover arithmetic and the durable adapter; native/Wasm minimum: msrv"
	@echo "Full release validation (or explicit check request): ci, msrv"

publish:
	+cargo publish -p $(PACKAGE) -p ic-metrics-stable --locked --registry crates-io

publish-check:
	+cargo publish -p $(PACKAGE) -p ic-metrics-stable --locked --registry crates-io --dry-run

hook-check:
	bash scripts/dev/test-format-hook.sh

ci-evidence-check:
	bash scripts/ci/test-native-source-files.sh
	bash scripts/ci/test-native-evidence.sh
	bash scripts/ci/test-native-recovery-evidence.sh

check:
	+cargo check --workspace --all-targets --locked

check-wasm:
	+cargo check --workspace --locked --target wasm32-unknown-unknown

clippy:
	+cargo clippy --workspace --all-targets --locked -- -D warnings
	+cargo clippy --workspace --lib --locked --target wasm32-unknown-unknown -- -D warnings

docs-check:
	+RUSTDOCFLAGS="-D warnings" cargo doc --workspace --locked --no-deps
	+RUSTDOCFLAGS="-D warnings" cargo doc --workspace --locked --no-deps --target wasm32-unknown-unknown

check-doc-links:
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		README.md AGENTS.md DRAGGINZGAME.md CHANGELOG.md docs/*.md \
		docs/principles/*.md docs/evidence/*.md docs/status/*.md rules/*.md audits/*.md tasks/*.md
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		crates/ic-metrics/src/application.md crates/ic-metrics-stable/README.md

test:
	+cargo test --workspace --locked

msrv:
	+bash scripts/ci/check-msrv.sh

check-pins:
	bash scripts/ci/check-dependency-pins.sh --cargo-inheritance

# Retention runs the full release and hook fixtures, plus failure/custody cases.
release-tools-check:
	bash scripts/release/test-fixture-retention.sh

# Keep order explicit: stop on a failed gate, including any Clippy warning.
ci:
	+$(MAKE) --no-print-directory shared-tooling-check
	+$(MAKE) --no-print-directory check-doc-links
	+$(MAKE) --no-print-directory tools-check
	+$(MAKE) --no-print-directory check-pins
	+$(MAKE) --no-print-directory ci-evidence-check
	+$(MAKE) --no-print-directory release-tools-check
	+$(MAKE) --no-print-directory fmt-check
	+$(MAKE) --no-print-directory check
	+$(MAKE) --no-print-directory check-wasm
	+$(MAKE) --no-print-directory clippy
	+$(MAKE) --no-print-directory docs-check
	+$(MAKE) --no-print-directory test
