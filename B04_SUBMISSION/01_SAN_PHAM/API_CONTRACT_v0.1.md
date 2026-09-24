# API CONTRACT v0.1
# ĐT-16 — Bảo tàng ảo và tour tham quan 360 độ trên nền web

## 1. Thông tin chung

- Base URL: `/api/v1`
- Kiểu giao tiếp: REST
- Dữ liệu: JSON
- Charset: UTF-8
- Version: v0.1
- Database: MySQL 8
- Backend: Laravel 11
- Frontend: Vue 3 + Vite
- Python service: FastAPI

## 2. Nguyên tắc

1. Frontend không truy cập MySQL trực tiếp.
2. Backend chịu trách nhiệm xác thực và phân quyền.
3. Controller chỉ tiếp nhận yêu cầu và trả phản hồi.
4. Service xử lý nghiệp vụ.
5. Model/Eloquent truy cập dữ liệu.
6. Tất cả dữ liệu đầu vào phải được kiểm tra hợp lệ ở server.
7. API version đặt trong `/api/v1`.
8. Không đưa mật khẩu hoặc `password_hash` vào API response của người dùng.
9. Các API yêu cầu đăng nhập phải kiểm tra phiên/token ở server.
10. Thông tin hành vi được ghi vào `behavior_events`.

---

# 3. Authentication

## POST /api/v1/auth/register

Mục đích:
Đăng ký tài khoản người dùng.

Request:

```json
{
  "name": "Nguyen Van A",
  "email": "a@example.com",
  "password": "MatKhauDemo123"
}
