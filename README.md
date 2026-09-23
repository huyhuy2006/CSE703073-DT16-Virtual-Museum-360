@'
# CSE703073 - ĐT-16: Bảo tàng ảo và Tour tham quan 360 độ

## 1. Thông tin dự án

**Mã học phần:** CSE703073  
**Đề tài:** ĐT-16 - Bảo tàng ảo và tour tham quan 360 độ trên nền web

### Bối cảnh

Tham quan ảo mở rộng khả năng tiếp cận di sản cho người không thể đến trực tiếp. Đề tài tập trung xây dựng trải nghiệm tham quan 360 độ có cấu trúc tự sự, kết hợp không gian tham quan, lớp tri thức và lộ trình dẫn dắt.

## 2. Mục tiêu

Xây dựng một hệ thống bảo tàng ảo trên nền web cho phép người dùng:

- Tham quan không gian bằng ảnh toàn cảnh 360 độ.
- Di chuyển giữa các không gian thông qua điểm chuyển cảnh.
- Xem thông tin hiện vật thông qua hotspot.
- Nghe thuyết minh âm thanh đa ngữ.
- Tham quan theo lộ trình chủ đề.
- Sử dụng chế độ tham quan tự do hoặc tham quan có dẫn dắt.
- Lưu hiện vật vào bộ sưu tập cá nhân.
- Gửi nội dung vào sổ lưu bút.
- Ghi nhận và phân tích hành vi tham quan.

## 3. Phạm vi chức năng

### 3.1. Không gian tham quan

- Quản lý bảo tàng.
- Quản lý không gian tham quan.
- Quản lý điểm nhìn.
- Quản lý ảnh panorama 360 độ.

### 3.2. Hotspot

- Hotspot thông tin hiện vật.
- Hotspot mô tả tri thức.
- Hotspot chuyển cảnh giữa các không gian.
- Hotspot được gắn vị trí trên panorama.

### 3.3. Thuyết minh

- Âm thanh tiếng Việt.
- Âm thanh tiếng Anh.
- Âm thanh tiếng Pháp.
- Có thể mở rộng thêm ngôn ngữ.

### 3.4. Tour

- Tour theo chủ đề.
- Tour có dẫn dắt.
- Tour tự do.
- Danh sách các bước tham quan.

### 3.5. Người dùng

- Đăng ký.
- Đăng nhập.
- Bộ sưu tập cá nhân.
- Sổ lưu bút.

### 3.6. Thống kê

- Không gian được xem.
- Panorama được xem.
- Hotspot được tương tác.
- Thời gian tham quan.
- Hành vi chuyển cảnh.
- Dữ liệu phục vụ phân tích bằng Python.

## 4. Kiến trúc công nghệ

```text
Vue 3 + Vite
       |
       | REST API
       v
Laravel 11
       |
       v
MySQL 8

Laravel
       |
       | API
       v
Python 3.12 + FastAPI
       |
       v
pandas / scikit-learn

## 5. Cấu trúc repository

CSE703073-DT16-Virtual-Museum-360/
│
├── backend/
├── frontend/
├── python-service/
├── database/
├── docker/
├── docs/
├── tests/
│
├── README.md
├── .gitignore
├── .env.example
└── docker-compose.yml

## 6. Công nghệ dự kiến

PHP 8.3
Laravel 11
MySQL 8
Vue 3
Vite
Python 3.12
FastAPI
pandas
scikit-learn
Docker
Git / GitHub

## 7. Nguyên tắc phát triển

Tách riêng Frontend, Backend và Python Service.
Backend thực hiện kiểm soát truy cập phía máy chủ.
Cấu hình môi trường sử dụng biến môi trường.
Không lưu password, API key hoặc secret trong Git.
Chức năng được phát triển theo feature branch.
Mỗi chức năng phải được kiểm thử trước khi merge.

## 8. Git workflow

main
  |
  └── dev
       |
       ├── feature/backend-auth
       ├── feature/backend-museum
       ├── feature/backend-panorama
       ├── feature/backend-hotspot
       ├── feature/backend-tour
       ├── feature/frontend-layout
       ├── feature/frontend-panorama
       └── feature/frontend-tour

Quy trình

dev
 ↓
feature/*
 ↓
code
 ↓
test
 ↓
commit
 ↓
push
 ↓
Pull Request
 ↓
dev
 ↓
main

## 9. Thành viên

| Thành viên    | Vai trò            | Phạm vi                       |
| ------------- | ------------------ | ----------------------------- |
| Chưa cập nhật | Backend Developer  | Laravel, API, business logic  |
| Chưa cập nhật | Frontend Developer | Vue 3, UI, panorama viewer    |
| Chưa cập nhật | Database           | MySQL, ERD, dữ liệu           |
| Chưa cập nhật | Python             | FastAPI, xử lý dữ liệu        |
| Chưa cập nhật | Testing/Deployment | Kiểm thử, bảo mật, triển khai |

## 10. Lưu ý về dữ liệu panorama

Ảnh panorama 360 độ có dung lượng lớn. Hệ thống sẽ hướng tới:

Lazy loading.
Phân mảnh/tile ảnh khi phù hợp.
Thumbnail riêng.
Tách tài nguyên media khỏi dữ liệu nghiệp vụ.
Theo dõi kích thước và thời gian tải tài nguyên.

## 11. Trạng thái dự án

Đang trong giai đoạn khởi tạo dự án.

## 12. Ghi chú học phần

Đây là sản phẩm học thuật thuộc học phần:

CSE703073 - Lập trình ứng dụng Web trong Du lịch 2