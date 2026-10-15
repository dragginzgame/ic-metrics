.DEFAULT_GOAL := help

PACKAGE := ic-metrics
MSRV ?= 1.85.0
STABLE_MSRV ?= 1.88.0
export RELEASE_DELIVERY ?= direct
export YQ := $(CURDIR)/.tools/host/bin/yq

# Common commands use this checkout's reviewed snapshot, including scratch exports.
override SHARED_TOOLING_ROOT := $(CURDIR)
export SHARED_TOOLING_ROOT
LOCAL_TOOL_INSTALL_TARGETS += install-wasm-inspector
LOCAL_TOOL_CHECK_TARGETS += wasm-inspector-tools-check
include make/consumer.mk

# PR delivery requires merged-checkout adapters and qualification we do not own.
# Refuse it before dispatching any release runner or metadata operation.
_release_targets := release-patch release-minor release-major release-resume release-version release-preflight release-verify release-prepare-version release-prepared-check release-files release-commit-check release-committed-check release-tagged-check release-push-check
ifneq ($(filter $(_release_targets),$(MAKECMDGOALS)),)
ifneq ($(RELEASE_DELIVERY),direct)
$(error ic-metrics supports RELEASE_DELIVERY=direct only)
endif
endif

.PHONY: $(_release_targets)

release-patch release-minor release-major release-resume: export IC_METRICS_RELEASE_CACHE_PREPARE := 1

release-version:
	@bash scripts/release/metadata.sh version

release-preflight:
	+@RUST_TOOL_VERSIONS="$(RUST_TOOL_VERSIONS)" bash scripts/release/metadata.sh preflight

release-verify:
	+env -u IC_METRICS_RELEASE_CACHE_PREPARE CARGO_NET_OFFLINE=true VALIDATION_FAILURE_LOG_DIR="$$(git rev-parse --git-path release-state)/validation-failures" \
		bash scripts/ci/run-validation-targets.sh --fail-fast --input Cargo.toml --input Cargo.lock ci msrv stable-msrv

release-prepare-version:
	+@bash scripts/release/metadata.sh prepare

release-commit-check:
	+@bash scripts/release/metadata.sh commit-check

release-prepared-check release-committed-check release-tagged-check release-push-check:
	+@bash scripts/release/metadata.sh check

release-files:
	@printf '%s\0' Cargo.toml Cargo.lock CHANGELOG.md

.PHONY: help publish publish-check install-hooks hook-check check check-wasm clippy docs-check check-doc-links test msrv shared-tooling-check check-pins pin-tools-check release-tools-check ci
.PHONY: local-tools-test ci-evidence-check
.PHONY: wasm-inspect-check install-wasm-inspector wasm-inspector-tools-check
.PHONY: stable-check stable-msrv

help:
	@echo "Local setup: install-tools; offline verification: tools-check"
	@echo "Reports: cloc (this workspace); fleet reports run in Shared Tooling"
	@echo "Maintainer releases: release-patch, release-minor, release-major; release-resume VERSION=X.Y.Z"
	@echo "Recovery: normal targets reconcile saved releases before validating a requested next increment"
	@echo "Registry: publish-check (dry run), publish (upload arithmetic and stable adapter to crates.io)"
	@echo "Rust setup: install-rust-tools; offline verification: rust-tools-check"
	@echo "Clone setup: install-hooks (requires prepared manifest formatter and rustfmt)"
	@echo "Focused: format-tools-check, fmt, fmt-check, check, check-wasm, clippy, docs-check, check-doc-links, msrv, shared-tooling-check, check-pins"
	@echo "Tooling fixtures: hook-check, release-tools-check, pin-tools-check (no release Git effects)"
	@echo "Local tool fixtures: local-tools-test (substitute downloads, no network)"
	@echo "CI evidence fixture: ci-evidence-check (substitute Make effects, no hosted run)"
	@echo "Named tests: cargo test -p $(PACKAGE) --locked <test-name>"
	@echo "Wasm evidence tool: install-wasm-inspector, wasm-inspector-tools-check, wasm-inspect-check"
	@echo "Maintenance task definitions: tasks/README.md (adoption does not activate a schedule)"
	@echo "Durable adapter: stable-check; separate native/Wasm minimum: stable-msrv"
	@echo "Full release validation (or explicit check request): ci, msrv, stable-msrv"

publish:
	+cargo publish -p $(PACKAGE) -p ic-metrics-stable --locked --registry crates-io

publish-check:
	+cargo publish -p $(PACKAGE) -p ic-metrics-stable --locked --registry crates-io --dry-run

local-tools-test:
	bash scripts/ci/test-make-consumer.sh
	bash scripts/ci/test-host-tools.sh
	bash scripts/ci/test-rust-tools.sh
	bash scripts/ci/test-ic-tools.sh
	bash scripts/ci/test-tool-downloads.sh
	bash scripts/ci/test-evidence-checksums.sh
	bash scripts/ci/test-tool-commands.sh
	bash scripts/ci/test-cloc.sh

hook-check:
	bash scripts/ci/test-rust-formatting-sources.sh
	bash scripts/dev/test-format-hook.sh

ci-evidence-check:
	bash scripts/ci/test-fixture-completion.sh
	bash scripts/ci/test-consumer-flow-probes.sh
	bash scripts/ci/test-workflow-step.sh
	bash scripts/ci/test-native-source-files.sh
	bash scripts/ci/test-native-host.sh
	bash scripts/ci/test-formatting-evidence.sh
	bash scripts/ci/test-evidence-archive.sh
	bash scripts/ci/test-native-evidence.sh

check:
	+cargo check -p $(PACKAGE) --locked

check-wasm:
	+cargo check -p $(PACKAGE) --locked --target wasm32-unknown-unknown

clippy:
	+cargo clippy -p $(PACKAGE) --all-targets --locked -- -D warnings
	+cargo clippy -p $(PACKAGE) --lib --locked --target wasm32-unknown-unknown -- -D warnings

docs-check:
	+RUSTDOCFLAGS="-D warnings" cargo doc -p $(PACKAGE) --locked --no-deps
	+RUSTDOCFLAGS="-D warnings" cargo doc -p $(PACKAGE) --locked --no-deps --target wasm32-unknown-unknown

check-doc-links:
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		README.md AGENTS.md DRAGGINZGAME.md CHANGELOG.md docs/*.md \
		docs/principles/*.md docs/evidence/*.md docs/status/*.md rules/*.md audits/*.md tasks/*.md
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		crates/ic-metrics/src/application.md crates/ic-metrics-stable/README.md

test:
	+cargo test -p $(PACKAGE) --locked

msrv:
	rustc +$(MSRV) --version
	+cargo +$(MSRV) --version
	+cargo +$(MSRV) check -p $(PACKAGE) --locked
	+cargo +$(MSRV) check -p $(PACKAGE) --locked --target wasm32-unknown-unknown

install-wasm-inspector:
	+bash scripts/dev/wasm-inspector.sh install

wasm-inspector-tools-check:
	+bash scripts/dev/wasm-inspector.sh check

wasm-inspect-check:
	+bash scripts/dev/test-wasm-inspector.sh

stable-check:
	+cargo check -p ic-metrics-stable --all-targets --locked
	+cargo check -p ic-metrics-stable --locked --target wasm32-unknown-unknown
	+cargo clippy -p ic-metrics-stable --all-targets --locked -- -D warnings
	+cargo clippy -p ic-metrics-stable --lib --locked --target wasm32-unknown-unknown -- -D warnings
	+RUSTDOCFLAGS="-D warnings" cargo doc -p ic-metrics-stable --locked --no-deps
	+RUSTDOCFLAGS="-D warnings" cargo doc -p ic-metrics-stable --locked --no-deps --target wasm32-unknown-unknown
	+cargo test -p ic-metrics-stable --locked tests::
	+cargo test -p ic-metrics-stable --locked --doc

stable-msrv:
	rustc +$(STABLE_MSRV) --version
	+cargo +$(STABLE_MSRV) check -p ic-metrics-stable --locked
	+cargo +$(STABLE_MSRV) check -p ic-metrics-stable --locked --target wasm32-unknown-unknown

check-pins:
	bash scripts/ci/check-dependency-pins.sh --cargo-inheritance

pin-tools-check:
	bash scripts/ci/test-dependency-pins.sh

release-tools-check:
	bash scripts/ci/test-format-tools.sh
	bash scripts/ci/test-release-runner.sh
	bash scripts/ci/test-release-tracking.sh
	bash scripts/release/test-standard-release.sh
	bash scripts/ci/test-cargo-release-metadata.sh
	bash scripts/ci/test-cargo-release-preflight.sh
	bash scripts/release/test-metadata.sh
	bash scripts/ci/test-release-source.sh
	bash scripts/release/test-release-admission.sh
	bash scripts/release/test-fixture-retention.sh

# Keep order explicit: stop on a failed gate, including any Clippy warning.
ci:
	+$(MAKE) --no-print-directory shared-tooling-check
	+$(MAKE) --no-print-directory check-doc-links
	+$(MAKE) --no-print-directory tools-check
	+$(MAKE) --no-print-directory check-pins
	+$(MAKE) --no-print-directory pin-tools-check
	+$(MAKE) --no-print-directory local-tools-test
	+$(MAKE) --no-print-directory ci-evidence-check
	+$(MAKE) --no-print-directory release-tools-check
	+$(MAKE) --no-print-directory hook-check
	+$(MAKE) --no-print-directory fmt-check
	+$(MAKE) --no-print-directory check
	+$(MAKE) --no-print-directory check-wasm
	+$(MAKE) --no-print-directory clippy
	+$(MAKE) --no-print-directory wasm-inspect-check
	+$(MAKE) --no-print-directory stable-check
	+$(MAKE) --no-print-directory docs-check
	+$(MAKE) --no-print-directory test
