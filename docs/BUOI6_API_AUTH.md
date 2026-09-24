# BUỔI 6 — BACKEND API, AUTHENTICATION & AUTHORIZATION

## 1. Thông tin

- Học phần: CSE703073 – Lập trình ứng dụng Web trong Du lịch 2
- Đề tài: ĐT-16. Bảo tàng ảo và tour tham quan 360 độ trên nền web
- Backend: PHP 8.3 + Laravel 11
- Database: MySQL 8
- Frontend: Vue 3 + Vite
- Authentication: Laravel session + Sanctum
- Authorization: Role middleware

## 2. Kiến trúc

Vue 3/Vite
→ Axios
→ Laravel API
→ Authentication / Authorization
→ MySQL virtual_museum_360

## 3. Authentication

### Login

POST /api/v1/auth/login

Request:

{
  "email": "admin@dt16.local",
  "password": "..."
}

### Current user

GET /api/v1/auth/me

Yêu cầu:

auth:sanctum

### Logout

POST /api/v1/auth/logout

Yêu cầu:

auth:sanctum

## 4. Authorization

Các vai trò được middleware hỗ trợ:

- admin
- supplier
- guide
- customer

Quyền được kiểm tra tại server.

Không dựa vào việc ẩn nút trên frontend.

## 5. Museum API

GET /api/v1/spaces

GET /api/v1/spaces/{id}

GET /api/v1/spaces/{id}/panoramas

GET /api/v1/spaces/{id}/artifacts

GET /api/v1/panoramas/{id}/hotspots

GET /api/v1/panoramas/{id}/transitions

GET /api/v1/panoramas/{id}/audio

GET /api/v1/languages

GET /api/v1/tours

GET /api/v1/tours/{id}

## 6. User API

GET /api/v1/collections

GET /api/v1/guestbook

Các endpoint trên lấy user_id từ session hiện tại.

## 7. Admin API

GET /api/v1/admin/check

GET /api/v1/admin/users

PATCH /api/v1/admin/users/{id}/status

Yêu cầu:

auth:sanctum
role:admin

## 8. Bảo mật

- Mật khẩu lưu bằng Argon2id.
- Không lưu mật khẩu dạng rõ.
- Login có rate limiting.
- Session ID được regenerate sau đăng nhập.
- Logout invalidate session.
- CSRF được xử lý bởi Sanctum.
- Cookie session HttpOnly.
- SameSite=lax.
- Không nối chuỗi SQL từ dữ liệu người dùng.
- Các truy vấn dùng Query Builder/Eloquent.
- Quyền được kiểm tra ở server.
- Truy cập trái phép được ghi log.

## 9. CSDL

Không chạy Laravel migrate trong Buổi 6.

Laravel đọc CSDL:

virtual_museum_360

Schema hiện tại của DT-16 gồm các nhóm dữ liệu:

- users
- museum_spaces
- panoramas
- artifacts
- hotspots
- space_transitions
- languages
- audio_narrations
- tours
- tour_stops
- guestbook_entries
- collections
- behavior_events

## 10. Minh chứng cần chụp

1. php artisan --version
2. composer show laravel/sanctum
3. php artisan route:list --path=api/v1
4. API health
5. Trang đăng nhập
6. Cookie XSRF-TOKEN
7. Cookie session
8. Đăng nhập thành công
9. /api/v1/auth/me
10. Admin PASS
11. Customer bị 403 khi gọi admin
12. Laravel → MySQL PASS
13. npm run build PASS
