-- =========================================================
-- CSE703073 - DT-16
-- BẢO TÀNG ẢO VÀ TOUR THAM QUAN 360 ĐỘ TRÊN NỀN WEB
-- Database schema
-- MySQL 8.x
-- =========================================================

CREATE DATABASE IF NOT EXISTS virtual_museum_360
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE virtual_museum_360;

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS behavior_events;
DROP TABLE IF EXISTS collections;
DROP TABLE IF EXISTS guestbook_entries;
DROP TABLE IF EXISTS tour_stops;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS audio_narrations;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS space_transitions;
DROP TABLE IF EXISTS hotspots;
DROP TABLE IF EXISTS artifacts;
DROP TABLE IF EXISTS panoramas;
DROP TABLE IF EXISTS museum_spaces;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;


-- =========================================================
-- 1. USERS
-- =========================================================

CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    name VARCHAR(150) NOT NULL,

    email VARCHAR(255) NOT NULL,

    password_hash VARCHAR(255) NOT NULL,

    role ENUM(
        'visitor',
        'editor',
        'admin'
    ) NOT NULL DEFAULT 'visitor',

    preferred_language_id BIGINT UNSIGNED NULL,

    avatar_url VARCHAR(500) NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    last_login_at DATETIME NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_users_email (email),

    KEY idx_users_role (role),

    KEY idx_users_active (is_active)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 2. LANGUAGES
-- =========================================================

CREATE TABLE languages (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    code VARCHAR(10) NOT NULL,

    name VARCHAR(100) NOT NULL,

    native_name VARCHAR(100) NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_languages_code (code)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 3. MUSEUM SPACES
-- =========================================================

CREATE TABLE museum_spaces (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    code VARCHAR(50) NOT NULL,

    name VARCHAR(200) NOT NULL,

    description TEXT NULL,

    floor_number INT NULL,

    building_name VARCHAR(200) NULL,

    display_order INT NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_museum_spaces_code (code),

    KEY idx_museum_spaces_active (is_active),

    KEY idx_museum_spaces_order (display_order),

    CONSTRAINT chk_museum_spaces_order
        CHECK (display_order >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 4. PANORAMAS
-- =========================================================

CREATE TABLE panoramas (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    museum_space_id BIGINT UNSIGNED NOT NULL,

    title VARCHAR(255) NOT NULL,

    description TEXT NULL,

    image_url VARCHAR(1000) NOT NULL,

    thumbnail_url VARCHAR(1000) NULL,

    tile_base_url VARCHAR(1000) NULL,

    projection_type ENUM(
        'equirectangular',
        'cubemap',
        'other'
    ) NOT NULL DEFAULT 'equirectangular',

    width_px INT UNSIGNED NULL,

    height_px INT UNSIGNED NULL,

    initial_yaw DECIMAL(8,3) NOT NULL DEFAULT 0,

    initial_pitch DECIMAL(8,3) NOT NULL DEFAULT 0,

    initial_fov DECIMAL(8,3) NOT NULL DEFAULT 75,

    display_order INT NOT NULL DEFAULT 0,

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    KEY idx_panoramas_space (museum_space_id),

    KEY idx_panoramas_active (is_active),

    KEY idx_panoramas_primary (museum_space_id, is_primary),

    CONSTRAINT fk_panoramas_space
        FOREIGN KEY (museum_space_id)
        REFERENCES museum_spaces(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_panoramas_yaw
        CHECK (initial_yaw >= -360 AND initial_yaw <= 360),

    CONSTRAINT chk_panoramas_pitch
        CHECK (initial_pitch >= -90 AND initial_pitch <= 90),

    CONSTRAINT chk_panoramas_fov
        CHECK (initial_fov > 0 AND initial_fov <= 180),

    CONSTRAINT chk_panoramas_width
        CHECK (width_px IS NULL OR width_px > 0),

    CONSTRAINT chk_panoramas_height
        CHECK (height_px IS NULL OR height_px > 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 5. ARTIFACTS
-- =========================================================

CREATE TABLE artifacts (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    museum_space_id BIGINT UNSIGNED NULL,

    inventory_code VARCHAR(100) NOT NULL,

    name VARCHAR(255) NOT NULL,

    short_description TEXT NULL,

    full_description LONGTEXT NULL,

    period_name VARCHAR(200) NULL,

    origin_place VARCHAR(255) NULL,

    material VARCHAR(255) NULL,

    dimensions VARCHAR(255) NULL,

    creator_name VARCHAR(255) NULL,

    image_url VARCHAR(1000) NULL,

    video_url VARCHAR(1000) NULL,

    display_order INT NOT NULL DEFAULT 0,

    is_featured BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_artifacts_inventory_code (inventory_code),

    KEY idx_artifacts_space (museum_space_id),

    KEY idx_artifacts_active (is_active),

    KEY idx_artifacts_featured (is_featured),

    KEY idx_artifacts_name (name),

    CONSTRAINT fk_artifacts_space
        FOREIGN KEY (museum_space_id)
        REFERENCES museum_spaces(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_artifacts_order
        CHECK (display_order >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 6. HOTSPOTS
-- =========================================================

CREATE TABLE hotspots (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    panorama_id BIGINT UNSIGNED NOT NULL,

    artifact_id BIGINT UNSIGNED NULL,

    hotspot_type ENUM(
        'artifact',
        'information',
        'navigation',
        'audio'
    ) NOT NULL,

    title VARCHAR(255) NOT NULL,

    description TEXT NULL,

    yaw DECIMAL(9,5) NOT NULL,

    pitch DECIMAL(9,5) NOT NULL,

    icon_name VARCHAR(100) NULL,

    target_url VARCHAR(1000) NULL,

    display_order INT NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    KEY idx_hotspots_panorama (panorama_id),

    KEY idx_hotspots_artifact (artifact_id),

    KEY idx_hotspots_type (hotspot_type),

    KEY idx_hotspots_active (is_active),

    CONSTRAINT fk_hotspots_panorama
        FOREIGN KEY (panorama_id)
        REFERENCES panoramas(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_hotspots_artifact
        FOREIGN KEY (artifact_id)
        REFERENCES artifacts(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_hotspots_yaw
        CHECK (yaw >= -360 AND yaw <= 360),

    CONSTRAINT chk_hotspots_pitch
        CHECK (pitch >= -90 AND pitch <= 90)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- 7. SPACE TRANSITIONS
-- =========================================================

CREATE TABLE space_transitions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    source_panorama_id BIGINT UNSIGNED NOT NULL,

    target_panorama_id BIGINT UNSIGNED NOT NULL,

    title VARCHAR(255) NOT NULL,

    description TEXT NULL,

    yaw DECIMAL(9,5) NOT NULL,

    pitch DECIMAL(9,5) NOT NULL,

    transition_style ENUM(
        'fade',
        'instant',
        'zoom'
    ) NOT NULL DEFAULT 'fade',

    display_order INT NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    KEY idx_transitions_source (source_panorama_id),

    KEY idx_transitions_target (target_panorama_id),

    KEY idx_transitions_active (is_active),

    CONSTRAINT fk_transitions_source
        FOREIGN KEY (source_panorama_id)
        REFERENCES panoramas(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_transitions_target
        FOREIGN KEY (target_panorama_id)
        REFERENCES panoramas(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_transitions_yaw
        CHECK (yaw >= -360 AND yaw <= 360),

    CONSTRAINT chk_transitions_pitch
        CHECK (pitch >= -90 AND pitch <= 90)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 8. AUDIO NARRATIONS
-- =========================================================

CREATE TABLE audio_narrations (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    language_id BIGINT UNSIGNED NOT NULL,

    artifact_id BIGINT UNSIGNED NULL,

    panorama_id BIGINT UNSIGNED NULL,

    hotspot_id BIGINT UNSIGNED NULL,

    title VARCHAR(255) NOT NULL,

    audio_url VARCHAR(1000) NOT NULL,

    transcript TEXT NULL,

    duration_seconds INT UNSIGNED NULL,

    voice_name VARCHAR(255) NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    KEY idx_audio_language (language_id),

    KEY idx_audio_artifact (artifact_id),

    KEY idx_audio_panorama (panorama_id),

    KEY idx_audio_hotspot (hotspot_id),

    CONSTRAINT fk_audio_language
        FOREIGN KEY (language_id)
        REFERENCES languages(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_audio_artifact
        FOREIGN KEY (artifact_id)
        REFERENCES artifacts(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_audio_panorama
        FOREIGN KEY (panorama_id)
        REFERENCES panoramas(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_audio_hotspot
        FOREIGN KEY (hotspot_id)
        REFERENCES hotspots(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_audio_duration
        CHECK (
            duration_seconds IS NULL
            OR duration_seconds > 0
        )

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 9. TOURS
-- =========================================================

CREATE TABLE tours (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    code VARCHAR(50) NOT NULL,

    name VARCHAR(255) NOT NULL,

    description TEXT NULL,

    mode ENUM(
        'free',
        'guided',
        'themed'
    ) NOT NULL DEFAULT 'free',

    estimated_minutes INT UNSIGNED NULL,

    difficulty ENUM(
        'easy',
        'medium',
        'hard'
    ) NOT NULL DEFAULT 'easy',

    cover_image_url VARCHAR(1000) NULL,

    display_order INT NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_tours_code (code),

    KEY idx_tours_mode (mode),

    KEY idx_tours_active (is_active),

    CONSTRAINT chk_tours_duration
        CHECK (
            estimated_minutes IS NULL
            OR estimated_minutes > 0
        )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 10. TOUR STOPS
-- =========================================================

CREATE TABLE tour_stops (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    tour_id BIGINT UNSIGNED NOT NULL,

    museum_space_id BIGINT UNSIGNED NOT NULL,

    panorama_id BIGINT UNSIGNED NULL,

    stop_order INT UNSIGNED NOT NULL,

    title VARCHAR(255) NULL,

    narration_text TEXT NULL,

    estimated_seconds INT UNSIGNED NULL,

    is_required BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_tour_stop_order (tour_id, stop_order),

    KEY idx_tour_stops_tour (tour_id),

    KEY idx_tour_stops_space (museum_space_id),

    KEY idx_tour_stops_panorama (panorama_id),

    CONSTRAINT fk_tour_stops_tour
        FOREIGN KEY (tour_id)
        REFERENCES tours(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_tour_stops_space
        FOREIGN KEY (museum_space_id)
        REFERENCES museum_spaces(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_tour_stops_panorama
        FOREIGN KEY (panorama_id)
        REFERENCES panoramas(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_tour_stops_order
        CHECK (stop_order >= 1),

    CONSTRAINT chk_tour_stops_duration
        CHECK (
            estimated_seconds IS NULL
            OR estimated_seconds > 0
        )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 11. GUESTBOOK ENTRIES
-- =========================================================

CREATE TABLE guestbook_entries (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    user_id BIGINT UNSIGNED NULL,

    display_name VARCHAR(150) NULL,

    message TEXT NOT NULL,

    rating TINYINT UNSIGNED NULL,

    status ENUM(
        'pending',
        'approved',
        'hidden'
    ) NOT NULL DEFAULT 'pending',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    KEY idx_guestbook_user (user_id),

    KEY idx_guestbook_status (status),

    KEY idx_guestbook_created (created_at),

    CONSTRAINT fk_guestbook_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_guestbook_rating
        CHECK (
            rating IS NULL
            OR rating BETWEEN 1 AND 5
        )

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 12. COLLECTIONS
-- =========================================================

CREATE TABLE collections (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    user_id BIGINT UNSIGNED NOT NULL,

    artifact_id BIGINT UNSIGNED NOT NULL,

    note TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_collections_user_artifact (
        user_id,
        artifact_id
    ),

    KEY idx_collections_user (user_id),

    KEY idx_collections_artifact (artifact_id),

    CONSTRAINT fk_collections_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_collections_artifact
        FOREIGN KEY (artifact_id)
        REFERENCES artifacts(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 13. BEHAVIOR EVENTS
-- Bảng hỗ trợ thống kê hành vi khách tham quan
-- =========================================================

CREATE TABLE behavior_events (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    user_id BIGINT UNSIGNED NULL,

    session_id VARCHAR(100) NOT NULL,

    event_type ENUM(
        'visit_space',
        'view_panorama',
        'view_artifact',
        'open_hotspot',
        'play_audio',
        'complete_tour',
        'start_tour',
        'add_collection',
        'remove_collection',
        'submit_guestbook'
    ) NOT NULL,

    museum_space_id BIGINT UNSIGNED NULL,

    panorama_id BIGINT UNSIGNED NULL,

    artifact_id BIGINT UNSIGNED NULL,

    hotspot_id BIGINT UNSIGNED NULL,

    tour_id BIGINT UNSIGNED NULL,

    event_data JSON NULL,

    occurred_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    KEY idx_behavior_user (user_id),

    KEY idx_behavior_session (session_id),

    KEY idx_behavior_type (event_type),

    KEY idx_behavior_time (occurred_at),

    KEY idx_behavior_space (museum_space_id),

    KEY idx_behavior_panorama (panorama_id),

    KEY idx_behavior_artifact (artifact_id),

    KEY idx_behavior_tour (tour_id),

    CONSTRAINT fk_behavior_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_behavior_space
        FOREIGN KEY (museum_space_id)
        REFERENCES museum_spaces(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_behavior_panorama
        FOREIGN KEY (panorama_id)
        REFERENCES panoramas(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_behavior_artifact
        FOREIGN KEY (artifact_id)
        REFERENCES artifacts(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_behavior_hotspot
        FOREIGN KEY (hotspot_id)
        REFERENCES hotspots(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_behavior_tour
        FOREIGN KEY (tour_id)
        REFERENCES tours(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- USERS -> LANGUAGES
-- FK được tạo sau khi languages tồn tại
-- =========================================================

ALTER TABLE users
ADD CONSTRAINT fk_users_language
    FOREIGN KEY (preferred_language_id)
    REFERENCES languages(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;


-- =========================================================
-- HOÀN TẤT
-- =========================================================

SET FOREIGN_KEY_CHECKS = 1;
