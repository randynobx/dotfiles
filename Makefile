# Release management for the `production` branch, which the infra repo's Ansible deploys
# to every lab host (infra ADR 0028). `main` is where work lands; `production` moves only
# when promoted here, and only forward.
#
#   make pending              what main has that production doesn't
#   make release              promote origin/main to production
#   make release REF=<sha>    promote a specific (already pushed) commit instead
#
# Rolling production back is deliberately not a target:
#   git push --force origin <sha>:production

REF ?= origin/main

.PHONY: release pending

pending:
	@git fetch -q origin
	@if git rev-parse -q --verify origin/production >/dev/null; then \
	  git log --oneline origin/production..origin/main; \
	else echo "no production branch yet: make release creates it"; fi

release:
	@git fetch -q origin
	@git rev-parse -q --verify "$(REF)^{commit}" >/dev/null || { echo "release: unknown ref $(REF)"; exit 1; }
	@git merge-base --is-ancestor "$(REF)" origin/main || { echo "release: $(REF) is not on origin/main (push it first)"; exit 1; }
	@sha=$$(git rev-parse "$(REF)^{commit}"); \
	git push origin "$$sha:refs/heads/production" && \
	echo "production -> $$(git rev-parse --short $$sha). Deploy: make run in infra/automation."
