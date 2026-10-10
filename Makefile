.DEFAULT_GOAL := help

PACKAGE := ic-metrics
MSRV ?= 1.85.0
WASM_INSPECT_MSRV ?= 1.88.0
export RELEASE_DELIVERY ?= direct
IC_TOOL_PINS ?= ci/ic-tools.tsv
HOST_TOOL_VERSIONS ?= ci/tool-versions.env
export YQ := $(CURDIR)/.tools/host/bin/yq

include make/tools.mk
include make/release.mk
include make/rust-format.mk

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
	+@bash scripts/release/metadata.sh preflight

release-verify:
	+env -u IC_METRICS_RELEASE_CACHE_PREPARE CARGO_NET_OFFLINE=true VALIDATION_FAILURE_LOG_DIR="$$(git rev-parse --git-path release-state)/validation-failures" \
		bash scripts/ci/run-validation-targets.sh --fail-fast ci msrv wasm-inspect-msrv

release-prepare-version:
	@bash scripts/release/metadata.sh prepare

release-commit-check:
	@bash scripts/release/metadata.sh commit-check

release-prepared-check release-committed-check release-tagged-check release-push-check:
	@bash scripts/release/metadata.sh check

release-files:
	@printf '%s\0' Cargo.toml Cargo.lock CHANGELOG.md

.PHONY: help publish publish-check install-hooks hook-check check check-wasm clippy docs-check check-doc-links test msrv shared-tooling-check check-pins pin-tools-check release-tools-check ci
.PHONY: local-tools-test ci-evidence-check
.PHONY: wasm-inspect-check wasm-inspect-msrv

help:
	@echo "Local setup: install-tools; offline verification: tools-check"
	@echo "Reports: cloc (this workspace); fleet reports run in Shared Tooling"
	@echo "Maintainer releases: release-patch, release-minor, release-major; release-resume VERSION=X.Y.Z"
	@echo "Recovery: normal targets reconcile saved releases before validating a requested next increment"
	@echo "Registry: publish-check (dry run), publish (upload ic-metrics to crates.io)"
	@echo "Rust setup: install-rust-tools; offline verification: rust-tools-check"
	@echo "Clone setup: install-hooks (requires prepared manifest formatter and rustfmt)"
	@echo "Focused: format-tools-check, fmt, fmt-check, check, check-wasm, clippy, docs-check, check-doc-links, msrv, shared-tooling-check, check-pins"
	@echo "Tooling fixtures: hook-check, release-tools-check, pin-tools-check (no release Git effects)"
	@echo "Local tool fixtures: local-tools-test (substitute downloads, no network)"
	@echo "CI evidence fixture: ci-evidence-check (substitute Make effects, no hosted run)"
	@echo "Named tests: cargo test -p $(PACKAGE) --locked <test-name>"
	@echo "Wasm evidence tool: wasm-inspect-check; separate host minimum: wasm-inspect-msrv"
	@echo "Maintenance task definitions: tasks/README.md (adoption does not activate a schedule)"
	@echo "Full delivery validation: ci, msrv, wasm-inspect-msrv; release commands remain explicit"

publish:
	cargo publish -p $(PACKAGE) --locked --registry crates-io

publish-check:
	cargo publish -p $(PACKAGE) --locked --registry crates-io --dry-run

install-hooks:
	bash scripts/dev/install-git-hooks.sh

local-tools-test:
	bash scripts/ci/test-host-tools.sh
	bash scripts/ci/test-rust-tools.sh
	bash scripts/ci/test-ic-tools.sh
	bash scripts/ci/test-evidence-checksums.sh
	bash scripts/ci/test-tool-commands.sh
	bash scripts/ci/test-cloc.sh

hook-check:
	bash scripts/dev/test-format-hook.sh

ci-evidence-check:
	bash scripts/ci/test-evidence-archive.sh
	bash scripts/ci/test-native-evidence.sh

check:
	cargo check -p $(PACKAGE) --locked

check-wasm:
	cargo check -p $(PACKAGE) --locked --target wasm32-unknown-unknown

clippy:
	cargo clippy -p $(PACKAGE) --all-targets --locked -- -D warnings
	cargo clippy -p $(PACKAGE) --lib --locked --target wasm32-unknown-unknown -- -D warnings

docs-check:
	RUSTDOCFLAGS="-D warnings" cargo doc -p $(PACKAGE) --locked --no-deps
	RUSTDOCFLAGS="-D warnings" cargo doc -p $(PACKAGE) --locked --no-deps --target wasm32-unknown-unknown

check-doc-links:
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		README.md AGENTS.md DRAGGINZGAME.md CHANGELOG.md docs/*.md \
		docs/principles/*.md docs/evidence/*.md docs/status/*.md rules/*.md audits/*.md tasks/*.md
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		crates/ic-metrics/src/application.md crates/ic-metrics-wasm-inspect/README.md

test:
	cargo test -p $(PACKAGE) --locked

msrv:
	rustc +$(MSRV) --version
	cargo +$(MSRV) --version
	cargo +$(MSRV) check -p $(PACKAGE) --locked
	cargo +$(MSRV) check -p $(PACKAGE) --locked --target wasm32-unknown-unknown

wasm-inspect-check:
	cargo check -p ic-metrics-wasm-inspect --all-targets --locked
	cargo clippy -p ic-metrics-wasm-inspect --all-targets --locked -- -D warnings
	cargo test -p ic-metrics-wasm-inspect --locked --bin ic-metrics-wasm-inspect args::tests
	cargo test -p ic-metrics-wasm-inspect --locked --bin ic-metrics-wasm-inspect report::tests
	cargo test -p ic-metrics-wasm-inspect --locked --test cli input_admission_controls_exit_and_report_publication -- --exact

wasm-inspect-msrv:
	rustc +$(WASM_INSPECT_MSRV) --version
	cargo +$(WASM_INSPECT_MSRV) --version
	cargo +$(WASM_INSPECT_MSRV) check -p ic-metrics-wasm-inspect --all-targets --locked

shared-tooling-check:
	bash scripts/ci/verify-shared-tooling-snapshot.sh

check-pins:
	bash scripts/ci/check-dependency-pins.sh --cargo-inheritance

pin-tools-check:
	bash scripts/ci/test-dependency-pins.sh

release-tools-check:
	bash scripts/ci/test-format-tools.sh
	bash scripts/ci/test-release-runner.sh
	bash scripts/ci/test-release-tracking.sh
	bash scripts/release/test-standard-release.sh
	bash scripts/release/test-metadata.sh
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
	+$(MAKE) --no-print-directory docs-check
	+$(MAKE) --no-print-directory test
