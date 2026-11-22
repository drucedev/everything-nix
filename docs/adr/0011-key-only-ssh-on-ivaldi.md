# 11. Key-only SSH on Ivaldi

Date: 2026-11-22

Status: Accepted

## Decision

SSH accepts keys only, with no root login. Thor's key is enough to reach the
headless box; add other keys before install. The console password set with
`passwd druce` still works.
