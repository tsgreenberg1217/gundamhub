# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

GundamHub is a monorepo containing three git submodules:

| Submodule | Tech | Purpose |
|-----------|------|---------|
| `GundamHub_app/` | React Native 0.84 / TypeScript | Mobile companion app (iOS + Android) |
| `aimuro/` | Spring Boot / Kotlin / Java 21 | AI chatbot (RAG) for Gundam TCG rules questions |
| `gundamhub-card-service/` | Spring Boot / Kotlin / Java 21 | GraphQL card data service |

Each submodule has its own `CLAUDE.md` with detailed per-service guidance — read that first when working within a submodule.

## Full Stack Build & Run

```bash
# Build all services and start everything via Docker Compose
./gundam-hub-build.sh
```

This script builds `gundamhub-card-service` (Gradle → Docker image `gundam-card-service`), then calls `aimuro/aimuro-build.sh`, then runs `docker-compose up -d`.

```bash
# Start infrastructure only (databases + Redis, skip app services)
docker-compose up -d redis postgres pgvector gundam-card-db

# Start everything
docker-compose up -d
```

## Infrastructure (docker-compose.yaml)

| Service | Image | Port | Purpose |
|---------|-------|------|---------|
| `redis` | redis:7-alpine | 6379 | SSE stream buffering for aimuro |
| `postgres` | postgres:latest | 5433→5432 | Conversation history DB (`aimuro-conversation-db`) |
| `pgvector` | custom image | 5432 | Vector store for RAG (`gundam-tcg-rules-vector-db`) |
| `gundam-card-db` | custom image | 27017 | MongoDB with pre-seeded card data |
| `card-service` | `gundam-card-service` | — | Card GraphQL service (cloud profile, connects to `gundam-card-db`) |
| `aimuro-service` | `aimuro-service-test` | 8080 | AI chatbot (prod profile, connects to pgvector + postgres + redis + card-service) |

`OPEN_AI_KEY` env var must be set before running `docker-compose up`.

## Service Ports

- **aimuro** (AI chat): `8080` (Docker) / `8080` (local)
- **card-service** (GraphQL): `8082` (local H2) / `8080` (Docker)
- **GundamHub_app** (mobile): connects to `localhost:8080` (aimuro) and `localhost:8082` (card-service)

## Submodule Workflow

```bash
# Clone with submodules
git clone --recurse-submodules <repo>

# Initialize submodules after a plain clone
git submodule update --init --recursive

# Pull latest for all submodules
git submodule update --remote
```

Changes within a submodule directory belong to that submodule's own git history. Commit inside the submodule, then update the parent repo's submodule pointer with a commit in this repo.
