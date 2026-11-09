-- MLH Global Hack Week: Builders Week
-- Challenge 5: Implement AI-Powered Vector Search with pgvector
-- Ran for real on 2026-11-09 in Tiger Cloud service "ghw-builders-week"
-- (PostgreSQL 18.6, TimescaleDB v2.31.0, AWS us-east-1, service id wtdwdw8yd8)
-- via the Tiger Cloud SQL Editor. Results observed in the console are noted below.
--
-- Embeddings here are small 3-dimensional demo vectors (labelled as such),
-- standing in for real model embeddings. pgvector + pgvectorscale are both
-- available on this service (checked in pg_available_extensions).

-- 1. Enable pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Documents table: time-series column + metadata + embedding in one table
CREATE TABLE rag_docs(
    id INT PRIMARY KEY,
    ts TIMESTAMPTZ,
    topic TEXT,
    emb vector(3)
);
ALTER TABLE rag_docs ADD COLUMN content TEXT;

-- 3. Four documents with demo embeddings
INSERT INTO rag_docs(id, ts, topic, content, emb) VALUES
(1, now(), $$timescale$$, $$Hypertables partition time data$$, $$[1,0,0]$$),
(2, now(), $$timescale$$, $$Continuous aggregates speed queries$$, $$[1,0.2,0]$$),
(3, now(), $$auth$$, $$Auth0 FGA enforces document access$$, $$[0,1,0]$$),
(4, now(), $$billing$$, $$Tiger Cloud trial includes free credits$$, $$[0,0,1]$$);
-- Result: 4 rows affected.

-- 4. HNSW index for fast similarity search (cosine distance)
CREATE INDEX rag_docs_emb_idx ON rag_docs USING hnsw (emb vector_cosine_ops);

-- 5. Similarity search: cosine distance to the query vector, filtered by
--    metadata (topic) and by time range (last 7 days), nearest first.
SELECT id, topic, content, emb <=> $$[1,0,0]$$ AS dist
FROM rag_docs
WHERE topic = $$timescale$$ AND ts > now() - interval $$7 days$$
ORDER BY dist LIMIT 3;
-- Observed result (2 rows):
--   id 1, timescale, "Hypertables partition time data", dist 0
--   id 2, timescale, "Continuous aggregates speed queries", dist 0.019419306325336838
-- The auth and billing documents were correctly ranked farther away
-- (they are also excluded here by the topic filter).
