# Triage Labels

Canonical roles map onto native beads fields first; only two need labels.

## Triage state

| Role              | In beads                                          | Meaning                                  |
| ----------------- | ------------------------------------------------- | ---------------------------------------- |
| `needs-triage`    | label `needs-triage`                              | Maintainer needs to evaluate this issue  |
| `needs-info`      | status `deferred` (`bd defer <id> --reason ...`)  | Waiting on reporter for more information |
| `ready-for-agent` | open, unblocked, no role label (`bd ready --exclude-label needs-triage,human --exclude-type epic`) | Fully specified, ready for an AFK agent |
| `ready-for-human` | label `human`                                     | Requires human implementation            |
| `wontfix`         | closed with `-r wontfix`                          | Will not be actioned                     |

## Type

Implementation tickets use the default type `task` (or `bug`).

| Role       | In beads      | Meaning                                                         |
| ---------- | ------------- | --------------------------------------------------------------- |
| `research` | type `spike`  | Standalone research ticket: one fact that needs its own session |
| `spec`     | type `epic`   | Published spec that its tickets are children of                 |

A spec is never ready for an agent; its tickets carry the triage state.
