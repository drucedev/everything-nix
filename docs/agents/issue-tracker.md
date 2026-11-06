# Issue tracker: Local Markdown

Issues and specs live as markdown files in `.scratch/`, which is gitignored:
durable memory on this machine, never committed.

- One feature per directory: `.scratch/<feature-slug>/`.
- The spec is `.scratch/<feature-slug>/spec.md`.
- Each ticket is its own file, `.scratch/<feature-slug>/issues/<NN>-<slug>.md`,
  numbered from `01`.
- Near the top of each file, a `Status:` line holds the triage state and a
  `Type:` line marks a spec or research ticket (roles in `triage-labels.md`).
- Comments append under a `## Comments` heading at the bottom.

**Publish** creates the file, and its directory if needed. **Fetch** reads the
file at the path or issue number the user gives.

## Blocking

List blockers in the blocked ticket's `## Blocked by` section as
repository-relative paths, or `None - can start immediately`. Publish blockers
first. A ticket is complete at `Status: closed`, a research ticket at
`Status: resolved`; a ticket can start only when every listed blocker exists
and is complete.

## Standalone research ticket

One fact that needs its own session: an issue file with `Type: research` whose
body states the question and the decision it gates.

- **Claim**: if `Status:` reads `claimed`, stop and say so; otherwise set
  `Status: claimed` and save before reading deeply.
- **Resolve**: append the answer, evidence, and consequences under
  `## Resolution`, set `Status: resolved`, and report the decision it unblocks.
