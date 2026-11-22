# 3. Keep llm-agents independent and use its binary cache

Date: 2026-11-22

Status: Accepted

## Context

`llm-agents` provides coding tools (Pi, Claude Code, T3 Code). It is tested
only against its own pinned nixpkgs-unstable, and Numtide's cache serves
prebuilt binaries for that pin. It has no x86_64-darwin builds.

## Decision

- The `llm-agents` input has no `follows`, which keeps the cached binaries
  valid.
- NixOS hosts trust `https://cache.numtide.com`.
- Agent tools are installed on the Linux hosts only.

## Consequences

The flake carries a second nixpkgs-unstable in its lock. Odin gets no
llm-agents packages.
