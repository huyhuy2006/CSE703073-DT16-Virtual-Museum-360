# Database - DT-16 Virtual Museum 360

## 1. Thông tin

Môn học: CSE703073 - Lập trình ứng dụng Web trong Du lịch 2

Đề tài:

ĐT-16. Bảo tàng ảo và tour tham quan 360 độ trên nền web.

Database:

virtual_museum_360

DBMS:

MySQL 8.x

---

## 2. Các file

### schema.sql

Tạo cấu trúc database, bảng, khóa chính, khóa ngoại, CHECK và INDEX.

### seed_data.sql

Nạp dữ liệu mẫu.

### quality_check.sql

Kiểm tra tính toàn vẹn dữ liệu.

### index_benchmark.sql

Kiểm tra kế hoạch thực thi và index.

### data_dictionary.md

Từ điển dữ liệu.

---

## 3. Các thực thể chính

1. users
2. museum_spaces
3. panoramas
4. artifacts
5. hotspots
6. space_transitions
7. languages
8. audio_narrations
9. tours
10. tour_stops
11. guestbook_entries
12. collections

Bảng mở rộng phục vụ phân tích:

13. behavior_events

---

## 4. Chức năng được hỗ trợ

- Không gian bảo tàng
- Panorama 360 độ
- Hotspot
- Hiện vật
- Chuyển cảnh
- Audio đa ngôn ngữ
- Tour tự do
- Tour có hướng dẫn
- Tour theo chủ đề
- Guestbook
- Bộ sưu tập cá nhân
- Thống kê hành vi

---

## 5. Chạy schema

PowerShell:

mysql -u root -p virtual_museum_360 < ".\database\schema.sql"

---

## 6. Nạp dữ liệu

PowerShell:

mysql -u root -p virtual_museum_360 < ".\database\seed_data.sql"

---

## 7. Kiểm tra chất lượng

PowerShell:

mysql -u root -p virtual_museum_360 < ".\database\quality_check.sql"

---

## 8. Kiểm tra index

PowerShell:

mysql -u root -p virtual_museum_360 < ".\database\index_benchmark.sql"
