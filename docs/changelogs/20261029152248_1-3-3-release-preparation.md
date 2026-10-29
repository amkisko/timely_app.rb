# Release preparation 1.3.3

## Participants

Andrei Makarov (@amkisko)

## Decisions

Ship 1.3.3 as a patch on main. Keep public API names. Include the pull_request test trigger and closed-prompt sign-in exit that the re-audit found still open after the earlier 1.3.3 commit.

## Effects

Product-facing CHANGELOG heading dated 2026-10-29. Added operator-visible outcomes: exit when the authorization code prompt is closed or blank; run tests on pull requests to main. Earlier 1.3.3 bullets (HTTP error types, redacted failed sign-in diagnostics, cancelled release on closed confirmation) remain.

## Next

Commit, then make release. No tag, push, or gem publication in the preparation session.

## Source

- ../reviews/20261029152248_engineering-audit-release-preparation.md
- ../issues/20261028093000_engineering-release-audit.md
- ../../CHANGELOG.md
