-- =========================================================
-- CSE703073 - DT-16
-- INDEX BENCHMARK
-- =========================================================

USE virtual_museum_360;


-- =========================================================
-- 1. KIỂM TRA TRUY VẤN TÌM PANORAMA THEO SPACE
-- =========================================================

EXPLAIN
SELECT
    id,
    title,
    image_url
FROM panoramas
WHERE museum_space_id = 2
  AND is_active = TRUE;


-- =========================================================
-- 2. KIỂM TRA TÌM HOTSPOT THEO PANORAMA
-- =========================================================

EXPLAIN
SELECT
    id,
    title,
    hotspot_type,
    yaw,
    pitch
FROM hotspots
WHERE panorama_id = 2
  AND is_active = TRUE;


-- =========================================================
-- 3. KIỂM TRA TÌM ARTIFACT THEO SPACE
-- =========================================================

EXPLAIN
SELECT
    id,
    inventory_code,
    name
FROM artifacts
WHERE museum_space_id = 2
  AND is_active = TRUE;


-- =========================================================
-- 4. KIỂM TRA EVENT THEO USER
-- =========================================================

EXPLAIN
SELECT
    event_type,
    occurred_at
FROM behavior_events
WHERE user_id = 3
ORDER BY occurred_at DESC;


-- =========================================================
-- 5. KIỂM TRA EVENT THEO THỜI GIAN
-- =========================================================

EXPLAIN
SELECT
    event_type,
    occurred_at
FROM behavior_events
WHERE occurred_at >= '2026-01-01'
ORDER BY occurred_at DESC;
