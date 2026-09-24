# CHƯƠNG 1. TỔNG QUAN ĐỀ TÀI

## 1.1. Tên đề tài

ĐT-16. Bảo tàng ảo và tour tham quan 360 độ trên nền web.

## 1.2. Bối cảnh

Tham quan bảo tàng trực tuyến giúp mở rộng khả năng tiếp cận
di sản và hiện vật đối với những người không thể trực tiếp đến
địa điểm tham quan.

Một hệ thống bảo tàng ảo chỉ dừng ở việc hiển thị hình ảnh
panorama chưa đủ để tạo thành một trải nghiệm tham quan có
cấu trúc. Người dùng cần có thông tin về hiện vật, hotspot,
đường đi giữa các không gian, thuyết minh đa ngôn ngữ và
lộ trình theo chủ đề.

Đề tài ĐT-16 xây dựng một hệ thống web kết hợp panorama 360°
với lớp thông tin và tour hướng dẫn.

## 1.3. Vấn đề cần giải quyết

Hệ thống cần giải quyết các yêu cầu:

1. Quản lý các không gian bảo tàng.
2. Quản lý panorama 360°.
3. Liên kết các scene/panorama với nhau.
4. Gắn hotspot với hiện vật.
5. Quản lý audio narration theo ngôn ngữ.
6. Xây dựng tour theo chủ đề.
7. Hỗ trợ chế độ tham quan tự do.
8. Hỗ trợ chế độ tham quan có hướng dẫn.
9. Cho phép ghi nhận guestbook.
10. Cho phép người dùng xây dựng collection cá nhân.
11. Thu thập hành vi tham quan phục vụ thống kê.

## 1.4. Mục tiêu

### Mục tiêu tổng quát

Xây dựng hệ thống bảo tàng ảo trên nền web cho phép người
dùng khám phá không gian bảo tàng bằng panorama 360°, tương
tác với hiện vật và tham gia tour tham quan theo chủ đề.

### Mục tiêu cụ thể

- Xây dựng mô hình dữ liệu đặc thù cho bảo tàng ảo.
- Xây dựng REST API.
- Xây dựng frontend Vue 3.
- Tích hợp cơ chế hotspot.
- Chuẩn bị cơ chế audio narration đa ngôn ngữ.
- Xây dựng tour free và guided.
- Quản lý guestbook và collection.
- Ghi nhận behavior events.
- Chuẩn bị mô-đun Python phục vụ thống kê và phân tích.

## 1.5. Phạm vi

Phạm vi hệ thống tập trung vào trải nghiệm tham quan bảo tàng
ảo trên nền web.

Hệ thống không tập trung vào việc xây dựng nền tảng thương mại
điện tử bán vé thực tế ở phiên bản hiện tại.

## 1.6. Đối tượng sử dụng

### Khách tham quan

- xem bảo tàng
- xem panorama
- mở hotspot
- nghe thuyết minh
- xem tour
- xem guestbook

### Người dùng đã đăng nhập

- sử dụng collection cá nhân
- gửi guestbook
- ghi nhận hành vi gắn với tài khoản

### Quản trị viên

- quản lý dữ liệu hệ thống
- quản lý không gian
- quản lý panorama
- quản lý hiện vật
- quản lý hotspot
- quản lý tour
- theo dõi dữ liệu hành vi

## 1.7. Công nghệ

- Frontend: Vue 3 + Vite
- Backend: Laravel 11
- Database: MySQL 8
- Python service: Python 3.12 + FastAPI
- Data processing: pandas
- Data analysis/recommendation: scikit-learn
- Version control: Git

## 1.8. Kiến trúc

Hệ thống sử dụng kiến trúc tách tầng:

- Tầng trình bày
- Tầng ứng dụng/nghiệp vụ
- Tầng dữ liệu

Frontend giao tiếp với Backend thông qua REST API.

Backend chịu trách nhiệm xác thực, phân quyền, kiểm tra dữ liệu
và điều phối nghiệp vụ.

Python service phục vụ các chức năng phân tích dữ liệu và hành vi.

## 1.9. Ý nghĩa

Đề tài tạo một không gian tham quan bảo tàng có cấu trúc,
trong đó hình ảnh 360° được kết hợp với lớp thông tin về
hiện vật, audio narration và tuyến tham quan.

Hệ thống đồng thời tạo nền tảng để phân tích hành vi tham quan
của người dùng phục vụ đánh giá và cải thiện trải nghiệm.

## 1.10. Kết quả dự kiến

Sau khi hoàn thiện:

- hệ thống chạy được trên nền web;
- có frontend responsive;
- có hai chủ đề giao diện;
- có API version v1;
- có dữ liệu bảo tàng;
- có panorama 360°;
- có hotspot;
- có audio đa ngôn ngữ;
- có tour free và guided;
- có guestbook;
- có collection;
- có behavior events;
- có mô-đun Python tích hợp.
