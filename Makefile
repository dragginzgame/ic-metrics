.DEFAULT_GOAL := help

PACKAGE := ic-metrics
MSRV ?= 1.88.0
RELEASE_REMOTE ?= origin
RELEASE_BRANCH ?= main
IC_TOOL_PINS ?= ci/ic-tools.tsv
HOST_TOOL_VERSIONS ?= ci/tool-versions.env
export YQ := $(CURDIR)/.tools/host/bin/yq

include make/tools.mk

# Rust setup stays explicit; checks only inspect the prepared local set.
install-tools: install-rust-tools
tools-check: rust-tools-check

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

.PHONY: help publish publish-check install-hooks hook-check format-tools-check fmt fmt-check check check-wasm clippy docs-check check-doc-links test msrv shared-tooling-check check-pins pin-tools-check release-tools-check ci
.PHONY: local-tools-test

help:
	@echo "Local setup: install-tools; offline verification: tools-check"
	@echo "Reports: cloc (this workspace); cloc-tooling (sibling tooling inventory)"
	@echo "Maintainer releases: release-patch, release-minor, release-major; release-resume VERSION=X.Y.Z"
	@echo "Recovery: normal targets reconcile saved releases before validating a requested next increment"
	@echo "Registry: publish-check (dry run), publish (upload ic-metrics to crates.io)"
	@echo "Rust setup: install-rust-tools; offline verification: rust-tools-check"
	@echo "Clone setup: install-hooks (requires prepared manifest formatter and rustfmt)"
	@echo "Focused: format-tools-check, fmt, fmt-check, check, check-wasm, clippy, docs-check, check-doc-links, msrv, shared-tooling-check, check-pins"
	@echo "Tooling fixtures: hook-check, release-tools-check, pin-tools-check (no release Git effects)"
	@echo "Local tool fixtures: local-tools-test (substitute downloads, no network)"
	@echo "Named tests: cargo test -p $(PACKAGE) --locked <test-name>"
	@echo "Full gates (explicit request or configured CI): test, ci"

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
	bash scripts/ci/test-cloc-tooling.sh

hook-check:
	bash scripts/dev/test-format-hook.sh

format-tools-check:
	@. "$(HOST_TOOL_VERSIONS)" && bash scripts/ci/check-format-tools.sh "$${SHARED_TOOLING_CARGO_SORT_VERSION:?}"

fmt: format-tools-check
	cargo sort --workspace
	cargo fmt --all

fmt-check: format-tools-check
	cargo sort --workspace --check
	cargo fmt --all -- --check

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
		docs/principles/*.md docs/evidence/*.md docs/status/*.md rules/*.md audits/*.md
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" crates/ic-metrics/src/application.md

test:
	cargo test -p $(PACKAGE) --locked

msrv:
	cargo +$(MSRV) check -p $(PACKAGE) --locked
	cargo +$(MSRV) check -p $(PACKAGE) --locked --target wasm32-unknown-unknown

shared-tooling-check:
	bash scripts/ci/verify-shared-tooling-snapshot.sh

check-pins:
	bash scripts/ci/check-dependency-pins.sh --cargo-inheritance

pin-tools-check:
	bash scripts/ci/test-dependency-pins.sh

release-tools-check:
	bash scripts/ci/test-format-tools.sh
	bash scripts/ci/test-release-runner.sh
	bash scripts/release/test-standard-release.sh
	bash scripts/release/test-metadata.sh
	bash scripts/release/test-release-admission.sh
	bash scripts/release/test-fixture-retention.sh

# Keep order explicit: stop on a failed gate, including any Clippy warning.
ci:
	+$(MAKE) --no-print-directory shared-tooling-check
	+$(MAKE) --no-print-directory check-doc-links
	+$(MAKE) --no-print-directory host-tools-check
	+$(MAKE) --no-print-directory rust-tools-check
	+$(MAKE) --no-print-directory check-pins
	+$(MAKE) --no-print-directory pin-tools-check
	+$(MAKE) --no-print-directory local-tools-test
	+$(MAKE) --no-print-directory release-tools-check
	+$(MAKE) --no-print-directory hook-check
	+$(MAKE) --no-print-directory fmt-check
	+$(MAKE) --no-print-directory check
	+$(MAKE) --no-print-directory check-wasm
	+$(MAKE) --no-print-directory clippy
	+$(MAKE) --no-print-directory docs-check
	+$(MAKE) --no-print-directory test
