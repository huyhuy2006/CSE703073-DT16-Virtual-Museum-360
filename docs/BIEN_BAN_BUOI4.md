# BIÊN BẢN BUỔI 4

## 1. Thông tin

- Học phần: CSE703073 — Lập trình ứng dụng Web trong Du lịch 2
- Đề tài: ĐT-16. Bảo tàng ảo và tour tham quan 360 độ trên nền web
- Buổi: 4
- Nội dung: Thiết kế kiến trúc, API và kế hoạch kiểm thử

## 2. Kết quả

### Kiến trúc

Đã chốt kiến trúc ba tầng:

1. Tầng trình bày: Vue 3 + Vite
2. Tầng ứng dụng/nghiệp vụ: Laravel 11
3. Tầng dữ liệu: MySQL 8

Python/FastAPI được xác định là dịch vụ dữ liệu độc lập phục vụ
phân tích hành vi.

### API

Đã xây dựng:

- API_CONTRACT_v0.1.md
- openapi.yaml

Base path:

/api/v1

### Giao diện

Đã dựng ba trang chính:

1. Trang chủ
2. Trang tham quan 360°
3. Trang tour theo chủ đề

Đã xây dựng:

- theme sáng
- theme tối
- responsive mobile
- responsive tablet
- responsive desktop

### Kiểm thử

Đã xây dựng bảng kiểm thử:

- 09 mô-đun
- 60 ca kiểm thử
- Normal
- Validation
- Authorization

## 3. Minh chứng

- docs/architecture.png
- docs/API_CONTRACT_v0.1.md
- docs/openapi.yaml
- docs/TEST_PLAN_60_CASES.xlsx
- frontend/

## 4. Quyết định kỹ thuật

Không cho frontend truy cập MySQL trực tiếp.

Backend là lớp duy nhất xử lý nghiệp vụ,
xác thực và phân quyền.

API được version hóa bằng `/api/v1`.

Frontend sử dụng design tokens cho hai theme.

## 5. Công việc chuyển sang Buổi 5

- Khởi tạo Laravel 11.
- Kết nối MySQL.
- Xác thực.
- Phiên làm việc.
- Phân quyền.
- Quản trị thực thể trọng tâm.
