# 9. Never change system.stateVersion

Date: 2026-11-22

Status: Accepted

## Decision

`system.stateVersion` is set at install and never changed afterwards: it pins
stateful migration behaviour, not the package set.
