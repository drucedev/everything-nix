# Triage Labels

Canonical roles map to identical strings in this tracker. The triage state goes
in an issue file's `Status:` line, the type in its `Type:` line.

## Triage state

| Role              | Meaning                                  |
| ----------------- | ---------------------------------------- |
| `needs-triage`    | Maintainer needs to evaluate this issue  |
| `needs-info`      | Waiting on reporter for more information |
| `ready-for-agent` | Fully specified, ready for an AFK agent  |
| `ready-for-human` | Requires human implementation            |
| `wontfix`         | Will not be actioned                     |

## Type

Implementation tickets carry no type.

| Role       | Meaning                                                         |
| ---------- | --------------------------------------------------------------- |
| `research` | Standalone research ticket: one fact that needs its own session |
| `spec`     | Published spec that its tickets are broken out from             |

A spec is never `ready-for-agent`; its tickets carry the triage state.
