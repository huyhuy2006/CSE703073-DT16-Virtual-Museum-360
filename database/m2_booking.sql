SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS tour_sessions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    tour_id BIGINT UNSIGNED NOT NULL,
    session_code VARCHAR(50) NOT NULL,
    starts_at DATETIME NOT NULL,
    ends_at DATETIME NOT NULL,
    capacity SMALLINT UNSIGNED NOT NULL DEFAULT 20,
    held_count INT UNSIGNED NOT NULL DEFAULT 0,
    confirmed_count INT UNSIGNED NOT NULL DEFAULT 0,
    status ENUM('open', 'closed', 'cancelled') NOT NULL DEFAULT 'open',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_tour_sessions_code (session_code),
    UNIQUE KEY uq_tour_sessions_tour_start (tour_id, starts_at),

    INDEX idx_tour_sessions_tour (tour_id),
    INDEX idx_tour_sessions_start (starts_at),
    INDEX idx_tour_sessions_status (status),
    INDEX idx_tour_sessions_search (status, starts_at),

    CONSTRAINT fk_tour_sessions_tour
        FOREIGN KEY (tour_id)
        REFERENCES tours(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_tour_sessions_time
        CHECK (ends_at > starts_at),

    CONSTRAINT chk_tour_sessions_counts
        CHECK (held_count + confirmed_count <= capacity)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS tour_bookings (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    booking_code CHAR(36) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    tour_session_id BIGINT UNSIGNED NOT NULL,
    quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    status ENUM(
        'pending_payment',
        'confirmed',
        'cancelled',
        'expired'
    ) NOT NULL DEFAULT 'pending_payment',
    expires_at DATETIME NULL,
    confirmed_at DATETIME NULL,
    cancelled_at DATETIME NULL,
    metadata JSON NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    UNIQUE KEY uq_tour_bookings_code (booking_code),

    INDEX idx_tour_bookings_user (user_id),
    INDEX idx_tour_bookings_session (tour_session_id),
    INDEX idx_tour_bookings_status (status),
    INDEX idx_tour_bookings_expiry (status, expires_at),
    INDEX idx_tour_bookings_user_status (user_id, status),

    CONSTRAINT fk_tour_bookings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_tour_bookings_session
        FOREIGN KEY (tour_session_id)
        REFERENCES tour_sessions(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_tour_bookings_quantity
        CHECK (quantity > 0)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS tour_booking_status_logs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    tour_booking_id BIGINT UNSIGNED NOT NULL,
    from_status VARCHAR(32) NULL,
    to_status VARCHAR(32) NOT NULL,
    note VARCHAR(500) NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    INDEX idx_booking_status_logs_booking (tour_booking_id),
    INDEX idx_booking_status_logs_created (created_at),

    CONSTRAINT fk_booking_status_logs_booking
        FOREIGN KEY (tour_booking_id)
        REFERENCES tour_bookings(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


SET @guided_tour_id := (
    SELECT id
    FROM tours
    WHERE name LIKE '%hÆ°á»›ng dáº«n%'
    ORDER BY id
    LIMIT 1
);

SET @guided_tour_id := COALESCE(
    @guided_tour_id,
    (
        SELECT id
        FROM tours
        ORDER BY id
        LIMIT 1 OFFSET 1
    ),
    (
        SELECT id
        FROM tours
        ORDER BY id
        LIMIT 1
    )
);


SELECT
    @guided_tour_id AS guided_tour_id;


INSERT IGNORE INTO tour_sessions (
    tour_id,
    session_code,
    starts_at,
    ends_at,
    capacity,
    held_count,
    confirmed_count,
    status,
    created_at,
    updated_at
)
WITH RECURSIVE seq AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM seq
    WHERE n < 300
)
SELECT
    @guided_tour_id,
    CONCAT('DT16-M2-', LPAD(n, 4, '0')),
    DATE_ADD(
        '2026-10-01 09:00:00',
        INTERVAL (n - 1) DAY
    ),
    DATE_ADD(
        '2026-10-01 10:00:00',
        INTERVAL (n - 1) DAY
    ),
    20,
    0,
    0,
    'open',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM seq;


SELECT
    COUNT(*) AS total_tour_sessions
FROM tour_sessions;


SELECT
    COUNT(*) AS total_tour_bookings
FROM tour_bookings;


SELECT
    COUNT(*) AS total_tour_booking_status_logs
FROM tour_booking_status_logs;
