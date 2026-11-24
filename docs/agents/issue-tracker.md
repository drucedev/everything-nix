# Issue tracker: beads (stealth)

Issues live in a local [beads](https://github.com/gastownhall/beads) database
(`bd`, installed on Thor), initialised with `bd init --stealth`: `.beads/` is
excluded through `.git/info/exclude`, so nothing reaches tracked files. Run
`bd` from the repository root; use `--json` when parsing output.

- **Spec**: an `epic` whose description holds the spec
  (`bd create "<title>" -t epic --body-file <file>`).
- **Ticket**: a child of its spec (`bd create "<title>" --parent <epic-id>
  --body-file <file>`), or a standalone issue.
- **Fetch**: `bd show <id>`; list with `bd list` or `bd ready`.
- **Comment**: `bd comment <id> "<text>"`.
- **Labels and states**: see `triage-labels.md`.

## Blocking

Record blockers as dependencies: `bd dep add <blocked> <blocker>`. Publish
blockers first. A ticket is complete when closed (`bd close <id> -r "<why>"`);
it can start only when `bd ready` lists it.

## Standalone research ticket

One fact that needs its own session: a `spike` whose description states the
question and the decision it gates.

- **Claim**: if it is `in_progress`, stop and say so; otherwise
  `bd update <id> --claim` before reading deeply.
- **Resolve**: comment the answer, evidence, and consequences, close it with
  `-r resolved`, and report the decision it unblocks.
