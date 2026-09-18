# Triage Labels

The workflow skills speak in terms of canonical triage roles. This file maps those roles to the actual label strings used in this repo's issue tracker.

## Triage state

| Canonical role    | Label in our tracker | Meaning                                  |
| ----------------- | -------------------- | ---------------------------------------- |
| `needs-triage`    | `needs-triage`       | Maintainer needs to evaluate this issue  |
| `needs-info`      | `needs-info`         | Waiting on reporter for more information |
| `ready-for-agent` | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human` | `ready-for-human`    | Requires human implementation            |
| `wontfix`         | `wontfix`            | Will not be actioned                     |

## Handler

Which Agent takes the item next. This is the axis a human reads to decide which Agent to open, and it is orthogonal to triage state.

| Canonical role      | Label in our tracker  | Meaning                                          |
| ------------------- | --------------------- | ------------------------------------------------ |
| `for-product-owner` | `agent:product-owner` | Needs a decision or shaping with the user        |
| `for-researcher`    | `agent:researcher`    | Needs facts established before it can be decided |
| `for-developer`     | `agent:developer`     | Implementation work for the implementing Agent   |

On this local-markdown tracker, the triage role goes in the `Status:` line of the issue file and the handler goes in an `Agent:` line holding just the handler name (`product-owner`, `researcher`, `developer`).

Applied automatically today:

- `/to-spec` stamps `ready-for-agent` and `for-product-owner` on a published spec.
- `/to-tickets` stamps `for-developer` on every implementation ticket, with `ready-for-agent` on an AFK slice and `ready-for-human` on a HITL one.
- `wayfinder` stamps `for-researcher` or `for-product-owner` on each decision ticket, which is also how the ticket records its type.

The remaining triage roles are consumed by triage tooling, which is not yet part of this workflow; they are recorded here so the vocabulary is stable when it arrives.
