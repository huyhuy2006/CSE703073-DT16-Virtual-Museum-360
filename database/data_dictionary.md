# TỪ ĐIỂN DỮ LIỆU

## Dự án

CSE703073 - ĐT-16. Bảo tàng ảo và tour tham quan 360 độ trên nền web.

---

# 1. users

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã người dùng |
| name | VARCHAR(150) | NOT NULL | Họ tên |
| email | VARCHAR(255) | UNIQUE | Email đăng nhập |
| password_hash | VARCHAR(255) | NOT NULL | Mật khẩu đã băm |
| role | ENUM | NOT NULL | visitor/editor/admin |
| preferred_language_id | BIGINT | FK | Ngôn ngữ ưu tiên |
| avatar_url | VARCHAR(500) | NULL | Ảnh đại diện |
| is_active | BOOLEAN | NOT NULL | Trạng thái tài khoản |
| last_login_at | DATETIME | NULL | Lần đăng nhập gần nhất |
| created_at | TIMESTAMP | NOT NULL | Thời điểm tạo |
| updated_at | TIMESTAMP | NOT NULL | Thời điểm cập nhật |

---

# 2. languages

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã ngôn ngữ |
| code | VARCHAR(10) | UNIQUE | Mã ngôn ngữ |
| name | VARCHAR(100) | NOT NULL | Tên ngôn ngữ |
| native_name | VARCHAR(100) | NOT NULL | Tên bản địa |
| is_active | BOOLEAN | NOT NULL | Trạng thái |
| created_at | TIMESTAMP | NOT NULL | Thời điểm tạo |
| updated_at | TIMESTAMP | NOT NULL | Thời điểm cập nhật |

---

# 3. museum_spaces

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã không gian |
| code | VARCHAR(50) | UNIQUE | Mã không gian |
| name | VARCHAR(200) | NOT NULL | Tên không gian |
| description | TEXT | NULL | Mô tả |
| floor_number | INT | NULL | Tầng |
| building_name | VARCHAR(200) | NULL | Tòa nhà |
| display_order | INT | NOT NULL | Thứ tự hiển thị |
| is_active | BOOLEAN | NOT NULL | Trạng thái |

---

# 4. panoramas

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã panorama |
| museum_space_id | BIGINT | FK | Không gian chứa panorama |
| title | VARCHAR(255) | NOT NULL | Tên panorama |
| description | TEXT | NULL | Mô tả |
| image_url | VARCHAR(1000) | NOT NULL | Ảnh 360 |
| thumbnail_url | VARCHAR(1000) | NULL | Ảnh thumbnail |
| tile_base_url | VARCHAR(1000) | NULL | Đường dẫn tile |
| projection_type | ENUM | NOT NULL | Kiểu chiếu |
| width_px | INT | NULL | Chiều rộng ảnh |
| height_px | INT | NULL | Chiều cao ảnh |
| initial_yaw | DECIMAL | NOT NULL | Góc quay ban đầu |
| initial_pitch | DECIMAL | NOT NULL | Góc nhìn dọc |
| initial_fov | DECIMAL | NOT NULL | Field of View |
| display_order | INT | NOT NULL | Thứ tự |
| is_primary | BOOLEAN | NOT NULL | Panorama chính |

---

# 5. artifacts

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã hiện vật |
| museum_space_id | BIGINT | FK | Không gian trưng bày |
| inventory_code | VARCHAR(100) | UNIQUE | Mã hiện vật |
| name | VARCHAR(255) | NOT NULL | Tên hiện vật |
| short_description | TEXT | NULL | Mô tả ngắn |
| full_description | LONGTEXT | NULL | Mô tả đầy đủ |
| period_name | VARCHAR(200) | NULL | Thời kỳ |
| origin_place | VARCHAR(255) | NULL | Nguồn gốc |
| material | VARCHAR(255) | NULL | Chất liệu |
| dimensions | VARCHAR(255) | NULL | Kích thước |
| creator_name | VARCHAR(255) | NULL | Người/tác giả |
| image_url | VARCHAR(1000) | NULL | Ảnh |
| video_url | VARCHAR(1000) | NULL | Video |
| display_order | INT | NOT NULL | Thứ tự |
| is_featured | BOOLEAN | NOT NULL | Hiện vật nổi bật |

---

# 6. hotspots

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã hotspot |
| panorama_id | BIGINT | FK | Panorama chứa hotspot |
| artifact_id | BIGINT | FK | Hiện vật liên kết |
| hotspot_type | ENUM | NOT NULL | Loại hotspot |
| title | VARCHAR(255) | NOT NULL | Tên hotspot |
| description | TEXT | NULL | Mô tả |
| yaw | DECIMAL | NOT NULL | Góc ngang |
| pitch | DECIMAL | NOT NULL | Góc dọc |
| icon_name | VARCHAR(100) | NULL | Biểu tượng |
| target_url | VARCHAR(1000) | NULL | URL đích |
| display_order | INT | NOT NULL | Thứ tự |
| is_active | BOOLEAN | NOT NULL | Trạng thái |

---

# 7. space_transitions

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã chuyển cảnh |
| source_panorama_id | BIGINT | FK | Panorama nguồn |
| target_panorama_id | BIGINT | FK | Panorama đích |
| title | VARCHAR(255) | NOT NULL | Tên chuyển cảnh |
| description | TEXT | NULL | Mô tả |
| yaw | DECIMAL | NOT NULL | Vị trí hotspot |
| pitch | DECIMAL | NOT NULL | Vị trí dọc |
| transition_style | ENUM | NOT NULL | Kiểu chuyển cảnh |
| display_order | INT | NOT NULL | Thứ tự |
| is_active | BOOLEAN | NOT NULL | Trạng thái |

---

# 8. audio_narrations

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã audio |
| language_id | BIGINT | FK | Ngôn ngữ |
| artifact_id | BIGINT | FK | Hiện vật |
| panorama_id | BIGINT | FK | Panorama |
| hotspot_id | BIGINT | FK | Hotspot |
| title | VARCHAR(255) | NOT NULL | Tên audio |
| audio_url | VARCHAR(1000) | NOT NULL | File audio |
| transcript | TEXT | NULL | Nội dung văn bản |
| duration_seconds | INT | NULL | Thời lượng |
| voice_name | VARCHAR(255) | NULL | Giọng đọc |

---

# 9. tours

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã tour |
| code | VARCHAR(50) | UNIQUE | Mã tour |
| name | VARCHAR(255) | NOT NULL | Tên tour |
| description | TEXT | NULL | Mô tả |
| mode | ENUM | NOT NULL | free/guided/themed |
| estimated_minutes | INT | NULL | Thời lượng |
| difficulty | ENUM | NOT NULL | Độ khó |
| cover_image_url | VARCHAR(1000) | NULL | Ảnh đại diện |
| display_order | INT | NOT NULL | Thứ tự |
| is_active | BOOLEAN | NOT NULL | Trạng thái |

---

# 10. tour_stops

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã điểm dừng |
| tour_id | BIGINT | FK | Tour |
| museum_space_id | BIGINT | FK | Không gian |
| panorama_id | BIGINT | FK | Panorama |
| stop_order | INT | NOT NULL | Thứ tự điểm dừng |
| title | VARCHAR(255) | NULL | Tên điểm dừng |
| narration_text | TEXT | NULL | Lời thuyết minh |
| estimated_seconds | INT | NULL | Thời lượng |
| is_required | BOOLEAN | NOT NULL | Có bắt buộc hay không |

---

# 11. guestbook_entries

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã lời nhắn |
| user_id | BIGINT | FK | Người dùng |
| display_name | VARCHAR(150) | NULL | Tên hiển thị |
| message | TEXT | NOT NULL | Nội dung |
| rating | TINYINT | CHECK 1-5 | Đánh giá |
| status | ENUM | NOT NULL | Trạng thái |
| created_at | TIMESTAMP | NOT NULL | Thời điểm tạo |

---

# 12. collections

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã bộ sưu tập |
| user_id | BIGINT | FK | Người dùng |
| artifact_id | BIGINT | FK | Hiện vật |
| note | TEXT | NULL | Ghi chú |
| created_at | TIMESTAMP | NOT NULL | Thời điểm thêm |

---

# 13. behavior_events

| Trường | Kiểu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| id | BIGINT | PK | Mã sự kiện |
| user_id | BIGINT | FK | Người dùng |
| session_id | VARCHAR(100) | NOT NULL | Phiên |
| event_type | ENUM | NOT NULL | Loại hành vi |
| museum_space_id | BIGINT | FK | Không gian |
| panorama_id | BIGINT | FK | Panorama |
| artifact_id | BIGINT | FK | Hiện vật |
| hotspot_id | BIGINT | FK | Hotspot |
| tour_id | BIGINT | FK | Tour |
| event_data | JSON | NULL | Dữ liệu mở rộng |
| occurred_at | DATETIME | NOT NULL | Thời điểm |

---

# Quan hệ quan trọng

- Một `museum_space` có nhiều `panoramas`.
- Một `panorama` có nhiều `hotspots`.
- Một `hotspot` có thể liên kết một `artifact`.
- Một `panorama` có thể có nhiều `space_transitions`.
- Một `tour` có nhiều `tour_stops`.
- Một `user` có nhiều `guestbook_entries`.
- Một `user` có nhiều `collections`.
- Một `user` có nhiều `behavior_events`.
- Một `language` có nhiều `audio_narrations`.
