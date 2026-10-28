.DEFAULT_GOAL := help

PACKAGE := ic-metrics
export MSRV
export RELEASE_DELIVERY ?= direct
export YQ := $(CURDIR)/.tools/host/bin/yq
LOCAL_TOOL_INSTALL_TARGETS := install-release-editor
LOCAL_TOOL_CHECK_TARGETS := release-editor-check
# Normal setup needs host/Cargo tools only; optional IC tools are selected explicitly.
IC_TOOLS :=

# These frozen manifests use archive-directory paths; retain their original bytes.
# All other maintained checksum manifests use repository-root paths.
# The inspection report receipt is current payload; its source receipt binds an
# old checkout and must not be compared with today's source files.
EVIDENCE_LOCAL_MANIFESTS := \
	docs/evidence/arithmetic-convergence-0112.tar.gz.sha256 \
	docs/evidence/checkpoint-cleanup-092.tar.gz.sha256 \
	docs/evidence/equality-owner-0111.tar.gz.sha256 \
	docs/evidence/identity-storage-0116.tar.gz.sha256 \
	docs/evidence/owner-convergence-091.tar.gz.sha256

# Common commands use this checkout's reviewed snapshot, including scratch exports.
override SHARED_TOOLING_ROOT := $(CURDIR)
export SHARED_TOOLING_ROOT
override RELEASE_DELIVERY_POLICY := $(CURDIR)/ci/release-delivery.txt
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
	+$(MAKE) --no-print-directory package-check

release-commit-check:
	+@bash scripts/release/metadata.sh commit-check

release-prepared-check release-committed-check release-tagged-check release-push-check:
	+@bash scripts/release/metadata.sh check

release-files:
	@bash scripts/release/metadata.sh files

.PHONY: help publish publish-check install-hooks hook-check check check-wasm clippy docs-check check-doc-links test msrv shared-tooling-check check-pins release-tools-check ci
.PHONY: ci-evidence-check evidence-check
.PHONY: production-dependencies-check
.PHONY: install-release-editor release-editor-check

install-release-editor:
	+@bash scripts/dev/release-editor.sh install

release-editor-check:
	+@bash scripts/dev/release-editor.sh check

help:
	@echo "Local setup: install-tools; offline verification: tools-check"
	@echo "Reports: cloc (this workspace); fleet reports run in Shared Tooling"
	@echo "Maintainer releases: release-patch, release-minor, release-major; release-resume VERSION=X.Y.Z"
	@echo "Normal releases start fresh from committed metadata; exact recovery: release-resume VERSION=X.Y.Z"
	@echo "Registry: publish-check (dry run), publish (upload arithmetic to crates.io)"
	@echo "Rust setup: install-rust-tools; offline verification: rust-tools-check"
	@echo "Release editor (also in install-tools/tools-check): install-release-editor, release-editor-check"
	@echo "Clone setup: install-hooks (requires prepared manifest formatter and rustfmt)"
	@echo "Focused: format-tools-check, fmt, fmt-check, check, check-wasm, clippy, docs-check, check-doc-links, shared-tooling-check, check-pins"
	@echo "Dependency declarations and boundary fixtures: production-dependencies-check"
	@echo "Tooling fixtures: hook-check, release-tools-check (no release Git effects)"
	@echo "CI evidence fixture: ci-evidence-check (substitute action results and Make effects, no hosted run)"
	@echo "Frozen evidence archive checksums (read-only): evidence-check"
	@echo "Named tests: cargo test -p $(PACKAGE) --locked <test-name>"
	@echo "Maintenance task definitions: tasks/README.md (adoption does not activate a schedule)"
	@echo "Workspace gates cover the arithmetic library; native/Wasm minimum: msrv"
	@echo "Full release validation (or explicit check request): ci, msrv"

publish:
	+$(MAKE) --no-print-directory clippy
	+cargo publish -p $(PACKAGE) --locked --registry crates-io

.PHONY: package-check

# Verify the arithmetic archive offline. No registry upload or version mutation.
package-check:
	+cargo package --workspace --all-features --locked --offline --allow-dirty

publish-check:
	+$(MAKE) --no-print-directory clippy
	+cargo publish -p $(PACKAGE) --locked --registry crates-io --dry-run

hook-check:
	bash scripts/dev/test-format-hook.sh

ci-evidence-check:
	bash scripts/ci/test-native-source-files.sh
	bash scripts/ci/test-native-evidence.sh
	bash scripts/ci/test-native-recovery-evidence.sh

evidence-check:
	bash scripts/ci/verify-evidence-checksums.sh $(filter-out $(EVIDENCE_LOCAL_MANIFESTS),$(wildcard docs/evidence/*.sha256)) docs/evidence/wasm-inspection-0215/reports.sha256
	cd docs/evidence && bash ../../scripts/ci/verify-evidence-checksums.sh $(notdir $(EVIDENCE_LOCAL_MANIFESTS))

check:
	+cargo check -p $(PACKAGE) --lib --no-default-features --locked
	+cargo check --workspace --all-targets --all-features --locked

check-wasm:
	+cargo check -p $(PACKAGE) --lib --no-default-features --locked --target wasm32-unknown-unknown
	+cargo check --workspace --all-features --locked --target wasm32-unknown-unknown

clippy:
	+cargo clippy --workspace --all-targets --all-features --locked -- -D warnings
	+cargo clippy --workspace --lib --all-features --locked --target wasm32-unknown-unknown -- -D warnings

docs-check:
	+RUSTDOCFLAGS="-D warnings" cargo doc --workspace --all-features --locked --no-deps
	+RUSTDOCFLAGS="-D warnings" cargo doc --workspace --all-features --locked --no-deps --target wasm32-unknown-unknown

check-doc-links:
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		README.md AGENTS.md DRAGGINZGAME.md CHANGELOG.md docs/*.md \
		docs/principles/*.md docs/evidence/*.md docs/status/*.md rules/*.md audits/*.md tasks/*.md
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		crates/ic-metrics/src/application.md

test:
	+cargo test --workspace --all-features --locked

msrv:
	+bash scripts/ci/check-msrv.sh

check-pins:
	bash scripts/ci/check-dependency-pins.sh --cargo-inheritance

production-dependencies-check:
	perl scripts/ci/check-production-dependencies.pl
	bash scripts/ci/test-production-dependencies.sh

# Retention runs the full release and hook fixtures, plus failure/custody cases.
release-tools-check:
	bash scripts/release/test-fixture-retention.sh

# Keep order explicit: stop on a failed gate, including any Clippy warning.
# Clippy checks all native targets and Wasm libraries; standalone checks stay focused.
ci:
	+$(MAKE) --no-print-directory shared-tooling-check
	+$(MAKE) --no-print-directory check-doc-links
	+$(MAKE) --no-print-directory evidence-check
	+$(MAKE) --no-print-directory tools-check
	+$(MAKE) --no-print-directory check-pins
	+$(MAKE) --no-print-directory fmt-check
	+$(MAKE) --no-print-directory clippy
	+$(MAKE) --no-print-directory production-dependencies-check
	+$(MAKE) --no-print-directory ci-evidence-check
	+$(MAKE) --no-print-directory release-tools-check
	+$(MAKE) --no-print-directory docs-check
	+$(MAKE) --no-print-directory test
	+$(MAKE) --no-print-directory package-check
