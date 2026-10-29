# Engineering and release audit

## Participants

Andrei Makarov (@amkisko)

## Decisions

Prepare 1.3.3 as a patch release on main. Keep the initial uncommitted documentation and release changes. Do not commit, tag, push or publish.

Review core behavior, executable tests, GitHub Actions, packaging, resource budgets, trace/privacy, security, contracts and release checks. Inspect external-service boundaries with synthetic fixtures. There is no application UI, independently operated worker, learned system, cloud deployment, physical plant, IPC or message broker in this library, so those surface-specific modes do not apply. CLI diagnostics are assessed through executable tests where present; no visual screen was changed.

## Effects

All listed fixes have high confidence and observed evidence from failing-then-passing executable tests or built-package inspection. Core findings are medium severity except package size and redundant reads, which are low. The smallest repair is described with each finding; no structural rewrite was needed.

- Response#error raised JSON::ParserError or TypeError for malformed or unexpected JSON, hiding the HTTP error class. Normalize non-object error bodies and preserve status-based errors; four 503 fixtures now raise ServerError.
- CLI#handle_auth_failure printed the authorization code and raw response after the HTTP logger had redacted them. Keep only the status in verbose authentication diagnostics. The regression captured both synthetic secret values before the fix and neither afterward.
- Release confirmation converted EOF to an empty affirmative answer. Add ReleaseVersionCheck.confirm_release? and reject EOF while preserving an entered empty line and y. Four examples cover EOF, entered default, y and n. The release script uses the checked helper; no publish command was executed.

Confirmed privacy finding: medium severity, high confidence. An operator enabling verbose authentication exposes the received authorization code and server response to terminal or captured logs. CLI#auth -> handle_auth_failure -> stdout crosses the intended redaction boundary. Likelihood requires verbose failure; demonstrated impact is both synthetic values in captured output. Fingerprint: secret-log:CLI.handle_auth_failure:stdout. Independent review confirmed the repair.

Set contents: read and concurrency cancel-in-progress on the test workflow; third-party actions stay pinned by commit. The earlier claim that pull_request was enabled was wrong: commit 21a4896 did not add that trigger. The 2026-10-29 re-audit added pull_request for branches: [main]. Workflow YAML, triggers, permissions and matrix paths were inspected locally; hosted GitHub Actions were not run.

Checks with Ruby 4.0.2 on arm64 macOS:

- POLYRUN_COVERAGE=1 make test: exit 0, including RuboCop, RBS validation and five test workers.
- bundle exec rspec --format progress: 120 examples, zero failures, zero pending.
- Coverage merge: 96.10% (394/410) tracked lines. Coverage is evidence for those assertions, not proof of all behavior.
- gem build timely-app.gemspec --output tmp/timely-app-release.gem, followed by Gem::Package#verify: pass. 15360 compressed bytes, 49 packaged files. Version, changelog heading and path-package lock entries agree.
- git diff --check: pass. Branch remains main.

Resource fixtures are local and use synthetic values. Cold `bundle exec ruby -Ilib -rtimely-app -e 'puts "loaded"'`, measured with `env time -l`: 0.21 CPU seconds and 31899648 bytes maximum RSS. This includes Bundler startup. Audit ceilings are one CPU second and 100 MiB RSS per cold load; both pass. No claim is made about other machines or co-located production services.

The 10,000-operation fixture in usr/reports/resource_smoke.rb measured 0.354939 wall seconds, 0.323605 CPU seconds, 1082720 allocated objects and 776 retained heap bytes after GC. The fixture budget is one CPU second and 1 MiB retained heap growth; both pass. CPU seconds are the energy proxy; no energy meter was available. These loops perform no file writes or network calls. Network-facing unit tests stub service responses; no live provider traffic or credentials were used. Persistent diagnostic and credential paths were inspected separately from these zero-IO loops.

Re-audit: checked the corrected failure paths, consumers, release metadata, package contents, negative tests and final diff. No remaining confirmed actionable finding was identified in the reviewed paths. This is a bounded local audit; live provider behavior, Ruby 3.4 and hosted matrix execution remain outside the measured run.

## Next

Re-audit closed the missing pull_request trigger and CLI authorization-code EOF path. See docs/reviews/20261029152248_engineering-audit-release-preparation.md. Review and commit, then make release. The command requires a clean worktree and interactive confirmation. No release has been published.

## Source

- AGENTS.md and .agents/skills/engineering-audit/.
- .agents/skills/changelog-update/.
- CHANGELOG.md, spec/, .github/workflows/test.yml and usr/reports/resource_smoke.rb.
- docs/reviews/20261029152248_engineering-audit-release-preparation.md.
