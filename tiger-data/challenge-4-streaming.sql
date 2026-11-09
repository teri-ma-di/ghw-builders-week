-- MLH Global Hack Week: Builders Week
-- Challenge 4: Build a Real-Time Streaming Analytics App
-- Ran for real on 2026-11-09 in Tiger Cloud service "ghw-builders-week"
-- (PostgreSQL 18.6, TimescaleDB v2.31.0, AWS us-east-1, service id wtdwdw8yd8)
-- via the Tiger Cloud SQL Editor. Results observed in the console are noted below.
--
-- Live event feed: simulated IoT sensor pings (3 devices, 1 ping/minute each
-- for the last 60 minutes). The dashboard surface used here is the Tiger Cloud
-- SQL Editor results grid over the continuous aggregate (a Grafana/Streamlit
-- dashboard was not deployed -- this is the honest scope of what was built).

-- 1. Events table, then a hypertable on the time column
CREATE TABLE sensor_events(
    time TIMESTAMPTZ NOT NULL,
    device TEXT,
    location TEXT,
    temperature DOUBLE PRECISION,
    humidity DOUBLE PRECISION
);
SELECT create_hypertable($$sensor_events$$, $$time$$);
-- Result: 1 row -- (2, public, sensor_events, t): the hypertable was created.

-- 2. Ingest the live feed: 60 minutes x 3 devices = 180 sensor pings
INSERT INTO sensor_events
SELECT now() - (g * interval $$1 minute$$),
$$ac-$$ || (1000 + d),
$$office$$,
68 + (g % 10) * 0.3,
40 + (g % 7)
FROM generate_series(0, 59) g,
generate_series(1, 3) d;
-- Result: 180 rows affected.

-- 3. Continuous aggregate: 5-minute rollups per device (the "instant insights"
--    layer a dashboard queries instead of scanning raw events)
CREATE MATERIALIZED VIEW sensor_5min
WITH (timescaledb.continuous) AS
SELECT time_bucket($$5 minutes$$, time) AS bucket,
device,
avg(temperature) AS avg_temp,
avg(humidity) AS avg_hum, count(*) AS n
FROM sensor_events
GROUP BY bucket, device
WITH NO DATA;
CALL refresh_continuous_aggregate($$sensor_5min$$, NULL, NULL);

-- 4. Live insights query (the dashboard query): latest 5-minute rollups
SELECT bucket, device,
round(avg_temp::numeric, 1) AS temp,
round(avg_hum::numeric, 1) AS hum, n
FROM sensor_5min
ORDER BY bucket DESC, device
LIMIT 12;
-- Observed result (12 rows, 0.4s), latest buckets first:
--   2026-11-09 16:05 ac-1001/1002/1003 temp 68.6 hum 42.0 n 5
--   2026-11-09 16:00 ac-1001/1002/1003 temp 70.1 hum 42.8 n 5
--   2026-11-09 15:55 ac-1001/1002/1003 temp 68.6 hum 43.6 n 5
--   2026-11-09 15:50 ac-1001/1002/1003 temp 70.1 hum 43.0 n 5
-- Each bucket holds exactly 5 events per device (1 ping/minute x 5 minutes).
