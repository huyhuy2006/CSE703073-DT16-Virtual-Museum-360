-- =========================================================
-- CSE703073 - DT-16
-- SAMPLE DATA
-- =========================================================

USE virtual_museum_360;

SET NAMES utf8mb4;

START TRANSACTION;


-- =========================================================
-- LANGUAGES
-- =========================================================

INSERT INTO languages
(code, name, native_name)
VALUES
('vi', 'Vietnamese', 'Tiếng Việt'),
('en', 'English', 'English'),
('fr', 'French', 'Français');


-- =========================================================
-- USERS
-- =========================================================

INSERT INTO users
(name, email, password_hash, role, preferred_language_id)
VALUES
(
    'Quản trị viên',
    'admin@dt16.test',
    '$2y$12$REPLACE_WITH_LARAVEL_HASH',
    'admin',
    1
),
(
    'Biên tập viên',
    'editor@dt16.test',
    '$2y$12$REPLACE_WITH_LARAVEL_HASH',
    'editor',
    1
),
(
    'Nguyễn Minh Anh',
    'visitor1@dt16.test',
    '$2y$12$REPLACE_WITH_LARAVEL_HASH',
    'visitor',
    1
),
(
    'John Smith',
    'visitor2@dt16.test',
    '$2y$12$REPLACE_WITH_LARAVEL_HASH',
    'visitor',
    2
);


-- =========================================================
-- MUSEUM SPACES
-- =========================================================

INSERT INTO museum_spaces
(code, name, description, floor_number, building_name, display_order)
VALUES
(
    'S01',
    'Sảnh chính',
    'Không gian mở đầu của bảo tàng ảo.',
    1,
    'Tòa nhà chính',
    1
),
(
    'S02',
    'Không gian văn hóa Đông Sơn',
    'Khu vực giới thiệu văn hóa Đông Sơn và các hiện vật tiêu biểu.',
    1,
    'Tòa nhà chính',
    2
),
(
    'S03',
    'Phòng Trống đồng',
    'Không gian trưng bày các loại trống đồng.',
    1,
    'Tòa nhà chính',
    3
),
(
    'S04',
    'Phòng lịch sử',
    'Không gian giới thiệu các hiện vật lịch sử.',
    2,
    'Tòa nhà chính',
    4
),
(
    'S05',
    'Phòng nghệ thuật',
    'Không gian giới thiệu các tác phẩm nghệ thuật.',
    2,
    'Tòa nhà chính',
    5
);


-- =========================================================
-- PANORAMAS
-- =========================================================

INSERT INTO panoramas
(
    museum_space_id,
    title,
    description,
    image_url,
    thumbnail_url,
    tile_base_url,
    projection_type,
    width_px,
    height_px,
    initial_yaw,
    initial_pitch,
    initial_fov,
    display_order,
    is_primary
)
VALUES
(
    1,
    'Panorama sảnh chính',
    'Toàn cảnh 360 độ sảnh chính.',
    '/storage/panoramas/sanh-chinh-01.jpg',
    '/storage/panoramas/thumbs/sanh-chinh-01.jpg',
    '/storage/panoramas/tiles/sanh-chinh-01/',
    'equirectangular',
    8000,
    4000,
    0,
    0,
    75,
    1,
    TRUE
),
(
    2,
    'Panorama văn hóa Đông Sơn',
    'Toàn cảnh khu trưng bày văn hóa Đông Sơn.',
    '/storage/panoramas/dong-son-01.jpg',
    '/storage/panoramas/thumbs/dong-son-01.jpg',
    '/storage/panoramas/tiles/dong-son-01/',
    'equirectangular',
    8000,
    4000,
    20,
    0,
    75,
    1,
    TRUE
),
(
    3,
    'Panorama phòng Trống đồng',
    'Toàn cảnh phòng Trống đồng.',
    '/storage/panoramas/trong-dong-01.jpg',
    '/storage/panoramas/thumbs/trong-dong-01.jpg',
    '/storage/panoramas/tiles/trong-dong-01/',
    'equirectangular',
    8000,
    4000,
    10,
    0,
    75,
    1,
    TRUE
),
(
    4,
    'Panorama phòng lịch sử',
    'Toàn cảnh phòng lịch sử.',
    '/storage/panoramas/lich-su-01.jpg',
    '/storage/panoramas/thumbs/lich-su-01.jpg',
    '/storage/panoramas/tiles/lich-su-01/',
    'equirectangular',
    8000,
    4000,
    -10,
    0,
    75,
    1,
    TRUE
),
(
    5,
    'Panorama phòng nghệ thuật',
    'Toàn cảnh phòng nghệ thuật.',
    '/storage/panoramas/nghe-thuat-01.jpg',
    '/storage/panoramas/thumbs/nghe-thuat-01.jpg',
    '/storage/panoramas/tiles/nghe-thuat-01/',
    'equirectangular',
    8000,
    4000,
    0,
    0,
    75,
    1,
    TRUE
);


-- =========================================================
-- ARTIFACTS
-- =========================================================

INSERT INTO artifacts
(
    museum_space_id,
    inventory_code,
    name,
    short_description,
    full_description,
    period_name,
    origin_place,
    material,
    dimensions,
    creator_name,
    display_order,
    is_featured
)
VALUES
(
    2,
    'DT16-ART-001',
    'Trống đồng Ngọc Lũ',
    'Một trong những hiện vật tiêu biểu của văn hóa Đông Sơn.',
    'Hiện vật được giới thiệu trong không gian văn hóa Đông Sơn với các thông tin lịch sử và giá trị văn hóa.',
    'Văn hóa Đông Sơn',
    'Việt Nam',
    'Đồng',
    'Đường kính khoảng 79 cm',
    'Thợ đúc đồng cổ',
    1,
    TRUE
),
(
    2,
    'DT16-ART-002',
    'Thạp đồng',
    'Hiện vật bằng đồng có hoa văn trang trí đặc trưng.',
    'Hiện vật được sử dụng làm tư liệu trực quan trong tour tham quan.',
    'Văn hóa Đông Sơn',
    'Việt Nam',
    'Đồng',
    NULL,
    'Thợ đúc đồng cổ',
    2,
    FALSE
),
(
    3,
    'DT16-ART-003',
    'Trống đồng cổ',
    'Hiện vật trung tâm của phòng Trống đồng.',
    'Mô hình hiện vật dùng để minh họa cho tuyến tham quan chuyên đề.',
    'Thời kỳ cổ',
    'Việt Nam',
    'Đồng',
    NULL,
    NULL,
    1,
    TRUE
),
(
    4,
    'DT16-ART-004',
    'Hiện vật lịch sử A',
    'Một hiện vật đại diện cho giai đoạn lịch sử.',
    'Nội dung thuyết minh chi tiết về hiện vật lịch sử.',
    'Lịch sử Việt Nam',
    'Việt Nam',
    'Kim loại',
    NULL,
    NULL,
    1,
    FALSE
),
(
    5,
    'DT16-ART-005',
    'Tác phẩm nghệ thuật A',
    'Tác phẩm được giới thiệu trong khu nghệ thuật.',
    'Thông tin giới thiệu và giá trị nghệ thuật của tác phẩm.',
    'Hiện đại',
    'Việt Nam',
    NULL,
    NULL,
    NULL,
    1,
    FALSE
);


-- =========================================================
-- HOTSPOTS
-- =========================================================

INSERT INTO hotspots
(
    panorama_id,
    artifact_id,
    hotspot_type,
    title,
    description,
    yaw,
    pitch,
    icon_name,
    display_order
)
VALUES
(
    2,
    1,
    'artifact',
    'Trống đồng Ngọc Lũ',
    'Mở thông tin chi tiết về hiện vật.',
    45.12500,
    -3.25000,
    'artifact',
    1
),
(
    2,
    2,
    'artifact',
    'Thạp đồng',
    'Mở thông tin về thạp đồng.',
    120.50000,
    2.75000,
    'artifact',
    2
),
(
    3,
    3,
    'artifact',
    'Trống đồng cổ',
    'Mở thông tin hiện vật.',
    -35.25000,
    -5.10000,
    'artifact',
    1
),
(
    2,
    NULL,
    'information',
    'Giới thiệu văn hóa Đông Sơn',
    'Mở nội dung giới thiệu về văn hóa Đông Sơn.',
    180.00000,
    0.00000,
    'info',
    3
);


-- =========================================================
-- SPACE TRANSITIONS
-- =========================================================

INSERT INTO space_transitions
(
    source_panorama_id,
    target_panorama_id,
    title,
    description,
    yaw,
    pitch,
    transition_style,
    display_order
)
VALUES
(
    1,
    2,
    'Đến không gian Đông Sơn',
    'Chuyển sang khu văn hóa Đông Sơn.',
    90.00000,
    0.00000,
    'fade',
    1
),
(
    2,
    3,
    'Đến phòng Trống đồng',
    'Chuyển sang phòng Trống đồng.',
    135.00000,
    0.00000,
    'fade',
    1
),
(
    3,
    4,
    'Đến phòng lịch sử',
    'Chuyển sang phòng lịch sử.',
    180.00000,
    0.00000,
    'fade',
    1
),
(
    4,
    5,
    'Đến phòng nghệ thuật',
    'Chuyển sang phòng nghệ thuật.',
    270.00000,
    0.00000,
    'fade',
    1
);


-- =========================================================
-- AUDIO NARRATIONS
-- =========================================================

INSERT INTO audio_narrations
(
    language_id,
    artifact_id,
    title,
    audio_url,
    transcript,
    duration_seconds,
    voice_name
)
VALUES
(
    1,
    1,
    'Thuyết minh Trống đồng Ngọc Lũ - Tiếng Việt',
    '/storage/audio/vi/trong-dong-ngoc-lu.mp3',
    'Nội dung thuyết minh bằng tiếng Việt.',
    120,
    'Vietnamese Female'
),
(
    2,
    1,
    'Ngoc Lu Drum - English',
    '/storage/audio/en/ngoc-lu-drum.mp3',
    'English narration for Ngoc Lu Drum.',
    120,
    'English Female'
),
(
    3,
    1,
    'Tambour de Ngoc Lu - Français',
    '/storage/audio/fr/ngoc-lu-drum.mp3',
    'Narration française du tambour de Ngoc Lu.',
    125,
    'French Female'
),
(
    1,
    2,
    'Thuyết minh Thạp đồng',
    '/storage/audio/vi/thap-dong.mp3',
    'Nội dung thuyết minh về thạp đồng.',
    90,
    'Vietnamese Female'
);


-- =========================================================
-- TOURS
-- =========================================================

INSERT INTO tours
(
    code,
    name,
    description,
    mode,
    estimated_minutes,
    difficulty,
    cover_image_url,
    display_order
)
VALUES
(
    'FREE-001',
    'Khám phá tự do',
    'Tự do khám phá toàn bộ bảo tàng ảo.',
    'free',
    60,
    'easy',
    '/storage/tours/free-tour.jpg',
    1
),
(
    'GUIDED-001',
    'Tour tham quan có hướng dẫn',
    'Tuyến tham quan được tổ chức theo trình tự định sẵn.',
    'guided',
    35,
    'easy',
    '/storage/tours/guided-tour.jpg',
    2
),
(
    'THEME-001',
    'Dấu ấn văn hóa Đông Sơn',
    'Tuyến tham quan chuyên đề về văn hóa Đông Sơn.',
    'themed',
    30,
    'easy',
    '/storage/tours/dong-son-tour.jpg',
    3
);


-- =========================================================
-- TOUR STOPS
-- =========================================================

INSERT INTO tour_stops
(
    tour_id,
    museum_space_id,
    panorama_id,
    stop_order,
    title,
    narration_text,
    estimated_seconds,
    is_required
)
VALUES
(
    2,
    1,
    1,
    1,
    'Sảnh chính',
    'Bắt đầu chuyến tham quan từ sảnh chính.',
    180,
    TRUE
),
(
    2,
    2,
    2,
    2,
    'Không gian Đông Sơn',
    'Khám phá văn hóa Đông Sơn.',
    600,
    TRUE
),
(
    2,
    3,
    3,
    3,
    'Phòng Trống đồng',
    'Tìm hiểu về trống đồng.',
    600,
    TRUE
),
(
    2,
    4,
    4,
    4,
    'Phòng lịch sử',
    'Tìm hiểu các hiện vật lịch sử.',
    600,
    TRUE
),
(
    3,
    2,
    2,
    1,
    'Văn hóa Đông Sơn',
    'Điểm dừng chuyên đề đầu tiên.',
    600,
    TRUE
),
(
    3,
    3,
    3,
    2,
    'Trống đồng',
    'Khám phá các hiện vật trống đồng.',
    900,
    TRUE
);


-- =========================================================
-- GUESTBOOK
-- =========================================================

INSERT INTO guestbook_entries
(
    user_id,
    display_name,
    message,
    rating,
    status
)
VALUES
(
    3,
    NULL,
    'Không gian tham quan 360 độ rất trực quan.',
    5,
    'approved'
),
(
    4,
    NULL,
    'Tôi thích phần thuyết minh đa ngôn ngữ.',
    5,
    'approved'
),
(
    NULL,
    'Khách tham quan',
    'Trải nghiệm bảo tàng ảo rất thú vị.',
    4,
    'approved'
);


-- =========================================================
-- COLLECTIONS
-- =========================================================

INSERT INTO collections
(
    user_id,
    artifact_id,
    note
)
VALUES
(
    3,
    1,
    'Hiện vật tôi yêu thích.'
),
(
    3,
    3,
    'Muốn tìm hiểu thêm.'
),
(
    4,
    1,
    'Interesting museum artifact.'
);


-- =========================================================
-- BEHAVIOR EVENTS
-- =========================================================

INSERT INTO behavior_events
(
    user_id,
    session_id,
    event_type,
    museum_space_id,
    panorama_id,
    artifact_id,
    hotspot_id,
    tour_id,
    event_data
)
VALUES
(
    3,
    'session-demo-001',
    'visit_space',
    1,
    1,
    NULL,
    NULL,
    NULL,
    JSON_OBJECT('source', 'homepage')
),
(
    3,
    'session-demo-001',
    'view_panorama',
    2,
    2,
    NULL,
    NULL,
    2,
    JSON_OBJECT('duration_seconds', 85)
),
(
    3,
    'session-demo-001',
    'view_artifact',
    2,
    2,
    1,
    1,
    2,
    JSON_OBJECT('duration_seconds', 45)
),
(
    3,
    'session-demo-001',
    'play_audio',
    2,
    2,
    1,
    1,
    2,
    JSON_OBJECT('language', 'vi')
),
(
    4,
    'session-demo-002',
    'start_tour',
    1,
    1,
    NULL,
    NULL,
    2,
    JSON_OBJECT('mode', 'guided')
);


COMMIT;
