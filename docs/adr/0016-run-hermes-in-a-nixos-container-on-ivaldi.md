# 16. Run Hermes Agent in a NixOS container on Ivaldi

Date: 2026-11-27

Status: Accepted

## Context

Hermes Agent runs messaging bots and a browser Webapp that LAN clients and
Hermes Desktop use. It should not share users, files, or a network address
with the host or with T3's agents.

## Decision

- Hermes runs in the NixOS container `hermes` with upstream's NixOS module in
  native mode. Upstream's Docker container mode was rejected: it is rootful,
  uses the host network, and makes the `docker` group root-equivalent.
- `privateUsers = "pick"` maps the container's root to an unprivileged host
  UID range.
- The container has its own LAN address through a macvlan on `enp1s0`. The
  host cannot reach that address, so T3's agents cannot reach the Webapp.
- The gateway serves the Webapp on `0.0.0.0:9120`. A non-loopback bind
  refuses sign-in until a dashboard auth provider is configured.
- The `hermes-agent` input supplies the module and package. The llm-agents
  package lacks the prebuilt Webapp and the attributes the module needs, so
  Hermes builds on Thor instead of coming from Numtide's cache. Thor's Hermes
  Desktop comes from the same input, so the app and the gateway match.
- Secrets live in `/var/lib/hermes-secrets/env` inside the container, root
  only, outside the service's writable paths. agenix decrypts on the host as
  root, which the container's mapped root cannot read.
- `container@hermes` is capped at 4 GB of memory.

## Consequences

- Secrets are not reproducible from the repository; back up the container's
  secrets file.
- The secrets file is merged into Hermes' `.env` when the container
  activates, so a change needs a container restart.
- The Webapp is plain HTTP on the LAN: sign-in passwords cross the network
  unencrypted and browsers disable features that need a secure context.
