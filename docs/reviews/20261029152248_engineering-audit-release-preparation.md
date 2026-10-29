# Engineering audit and release preparation

## Participants

Andrei Makarov (@amkisko)

## Decisions

- Continue on main. Keep version 1.3.3. Set the CHANGELOG heading date to 2026-10-29. RubyGems still lists 1.3.2 as the latest published version; git has no 1.3.3 tag.
- Do not commit, tag, push, or publish in this session.
- Repair the missing pull_request trigger on the test workflow and the CLI authorization-code EOF path before publication.

## Effects

- Enable pull_request on the test workflow for branches: [main]. Keep concurrency cancel-in-progress and permissions contents: read. Third-party actions remain pinned by commit SHA.
- CLI#authorize_via_browser now treats nil or blank gets as a required-code failure and exits 1 instead of NoMethodError. Two examples cover closed input and a blank line.
- Final checks with Ruby 4.0.2 on arm64 macOS: POLYRUN_COVERAGE=1 make test exit 0 (RuboCop, RBS validate, five polyrun workers). bundle exec rspec --format progress: 122 examples, zero failures, zero pending. Coverage merge on lib/: 96.14% (398/414) tracked lines. Coverage is evidence for those assertions, not proof of all behavior.
- gem build timely-app.gemspec --output tmp/timely-app-release.gem, followed by Gem::Package#verify: pass. 15360 compressed bytes, 49 packaged files. Version, changelog heading and path-package lock entries agree at 1.3.3. Package contains lib/, bin/, sig/, README, CHANGELOG, LICENSE, and gemspec only.
- Cold load measured with /usr/bin/time -l and bundle exec ruby -Ilib -rtimely-app: 0.16 user CPU seconds, 30294016 bytes maximum RSS. Audit ceilings are one CPU second and 100 MiB RSS; both pass. Includes Bundler startup. No claim about other machines or co-located services.
- usr/reports/resource_smoke.rb 10,000-operation fixture: 0.285853 wall seconds, 0.285184 CPU seconds, 1075730 allocated objects, 776 retained heap bytes after GC. Fixture budget: one CPU second and 1 MiB retained heap growth; both pass. CPU seconds are the energy proxy. Loops perform no file writes or network calls.
- git diff --check: pass. Re-checked Response#error status preservation, CLI verbose auth redaction, and ReleaseVersionCheck.confirm_release? EOF refusal; all still hold with executable evidence.
- Modes skipped with reason: no application UI; no independently operated worker; no learned system; no cloud deployment topology; no physical plant. Boundary and control still applies to the Timely HTTP/OAuth client path; fixtures stay synthetic and stubbed.
- Confirmed and repaired: prior audit claimed pull_request on test.yml, but the 21a4896 diff only added concurrency and contents: read. That gap is closed in this tree. CLI gets.chomp on closed stdin was a low-severity companion to the release-confirmation EOF fix; also closed.
- No remaining confirmed actionable finding identified in the reviewed paths after those repairs. Hosted GitHub Actions matrix and live Timely API behavior remain outside the measured run.

## Next

- Review and commit the prepared changes. Then run make release (clean worktree, interactive confirmation) for gem push, tag 1.3.3, origin push, and gh release create. This session did not run those steps.

## Source

- AGENTS.md
- .agents/skills/engineering-audit/
- .agents/skills/changelog-update/
- docs/issues/20261028093000_engineering-release-audit.md
- docs/changelogs/20261028093000_engineering-release-preparation.md
- CHANGELOG.md
- Makefile
- usr/bin/release.rb
- usr/reports/resource_smoke.rb
