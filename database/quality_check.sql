-- =========================================================
-- CSE703073 - DT-16
-- DATABASE QUALITY CHECK
-- =========================================================

USE virtual_museum_360;


-- =========================================================
-- 1. KIỂM TRA SỐ BẢNG
-- =========================================================

SELECT
    COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema = 'virtual_museum_360';


-- =========================================================
-- 2. KIỂM TRA SỐ BẢN GHI
-- =========================================================

SELECT 'users' AS table_name, COUNT(*) AS total
FROM users

UNION ALL

SELECT 'museum_spaces', COUNT(*)
FROM museum_spaces

UNION ALL

SELECT 'panoramas', COUNT(*)
FROM panoramas

UNION ALL

SELECT 'artifacts', COUNT(*)
FROM artifacts

UNION ALL

SELECT 'hotspots', COUNT(*)
FROM hotspots

UNION ALL

SELECT 'space_transitions', COUNT(*)
FROM space_transitions

UNION ALL

SELECT 'languages', COUNT(*)
FROM languages

UNION ALL

SELECT 'audio_narrations', COUNT(*)
FROM audio_narrations

UNION ALL

SELECT 'tours', COUNT(*)
FROM tours

UNION ALL

SELECT 'tour_stops', COUNT(*)
FROM tour_stops

UNION ALL

SELECT 'guestbook_entries', COUNT(*)
FROM guestbook_entries

UNION ALL

SELECT 'collections', COUNT(*)
FROM collections

UNION ALL

SELECT 'behavior_events', COUNT(*)
FROM behavior_events;


-- =========================================================
-- 3. PANORAMA KHÔNG CÓ SPACE
-- =========================================================

SELECT
    COUNT(*) AS invalid_panoramas
FROM panoramas p
LEFT JOIN museum_spaces s
    ON s.id = p.museum_space_id
WHERE s.id IS NULL;


-- =========================================================
-- 4. HOTSPOT KHÔNG CÓ PANORAMA
-- =========================================================

SELECT
    COUNT(*) AS invalid_hotspots
FROM hotspots h
LEFT JOIN panoramas p
    ON p.id = h.panorama_id
WHERE p.id IS NULL;


-- =========================================================
-- 5. KIỂM TRA HOTSPOT ARTIFACT
-- =========================================================

SELECT
    COUNT(*) AS invalid_artifact_hotspots
FROM hotspots
WHERE hotspot_type = 'artifact'
  AND artifact_id IS NULL;


-- =========================================================
-- 6. KIỂM TRA TỌA ĐỘ HOTSPOT
-- =========================================================

SELECT
    COUNT(*) AS invalid_coordinates
FROM hotspots
WHERE yaw < -360
   OR yaw > 360
   OR pitch < -90
   OR pitch > 90;


-- =========================================================
-- 7. KIỂM TRA TRANSITION TỰ TRỎ
-- =========================================================

SELECT
    COUNT(*) AS invalid_transitions
FROM space_transitions
WHERE source_panorama_id = target_panorama_id;


-- =========================================================
-- 8. KIỂM TRA TOUR STOP
-- =========================================================

SELECT
    t.name AS tour_name,
    COUNT(ts.id) AS total_stops
FROM tours t
LEFT JOIN tour_stops ts
    ON ts.tour_id = t.id
GROUP BY
    t.id,
    t.name
ORDER BY
    t.id;


-- =========================================================
-- 9. KIỂM TRA AUDIO
-- =========================================================

SELECT
    COUNT(*) AS invalid_audio
FROM audio_narrations
WHERE artifact_id IS NULL
  AND panorama_id IS NULL
  AND hotspot_id IS NULL;


-- =========================================================
-- 10. KIỂM TRA COLLECTION TRÙNG
-- =========================================================

SELECT
    user_id,
    artifact_id,
    COUNT(*) AS duplicate_count
FROM collections
GROUP BY
    user_id,
    artifact_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 11. KIỂM TRA FOREIGN KEY
-- =========================================================

SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'virtual_museum_360'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY
    TABLE_NAME,
    CONSTRAINT_NAME;


-- =========================================================
-- 12. KIỂM TRA INDEX
-- =========================================================

SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'virtual_museum_360'
ORDER BY
    TABLE_NAME,
    INDEX_NAME,
    SEQ_IN_INDEX;
