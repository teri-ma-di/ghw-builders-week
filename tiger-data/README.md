# Tiger Data — Builders Week Challenges 3, 4 and 5

All work ran for real on 2026-11-09 in the Tiger Cloud service **ghw-builders-week** (PostgreSQL 18.6, TimescaleDB v2.31.0, AWS us-east-1, service id `wtdwdw8yd8`, project `ote3kavgp7`), using the Tiger Cloud SQL Editor. The `conditions` hypertable from Challenge 1 (2 rows) was already in the service and was left untouched.

## Challenge 3 — Supercharge AI Agents with Tiger CLI or MCP Server

**Status: blocked in this environment — see `challenge-3-mcp.md`.** Tiger MCP is bundled with the Tiger CLI and must be installed on a local machine (`curl` install script, `tiger auth login`, `tiger mcp install`); this browser-only environment has no terminal, so no CLI/MCP connection could be run here. The setup steps and the manual MCP config are documented in `challenge-3-mcp.md` so the connection can be completed on a local machine in a few minutes. It was not submitted as done.

## Challenge 4 — Build a Real-Time Streaming Analytics App

Script: `challenge-4-streaming.sql`.

- `sensor_events` table converted to a hypertable on `time`.
- Simulated live IoT feed ingested: 180 pings (3 devices `ac-1001..1003`, 1 ping/minute for the last 60 minutes).
- Continuous aggregate `sensor_5min` (5-minute buckets per device: avg temperature, avg humidity, count) created and refreshed.
- Live-insights query returns the latest 12 buckets in 0.4s — e.g. 16:05 ac-1001 temp 68.6, hum 42.0, n 5; 16:00 temp 70.1, hum 42.8, n 5.
- Honest scope: the dashboard surface used is the Tiger Cloud SQL Editor results grid over the continuous aggregate; no separate Grafana/Streamlit dashboard was deployed.

## Challenge 5 — Implement AI-Powered Vector Search with pgvector

Script: `challenge-5-pgvector.sql`.

- `vector` and `vectorscale` extensions are both available on the service; `CREATE EXTENSION vector` was run.
- `rag_docs` table holds a time column, topic metadata and a 3-D demo embedding per document (4 docs; the embeddings are labelled demo vectors, standing in for real model embeddings).
- HNSW index `rag_docs_emb_idx` on `(emb vector_cosine_ops)`.
- Similarity search (`emb <=> '[1,0,0]'` cosine distance) filtered by topic and by a 7-day time range returned 2 rows: id 1 ("Hypertables partition time data", dist 0) and id 2 ("Continuous aggregates speed queries", dist 0.0194).
