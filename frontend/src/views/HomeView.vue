<template>
  <section class="page">
    <div class="container">
      <div class="hero">
        <div>
          <span class="badge">
            ĐT-16
          </span>

          <h1 class="hero__title">
            Khám phá bảo tàng
            theo cách hoàn toàn mới
          </h1>

          <p class="hero__text">
            Hệ thống bảo tàng ảo cho phép người tham quan
            khám phá không gian 360°, xem hiện vật tại
            hotspot, nghe thuyết minh đa ngôn ngữ và
            theo dõi các tour tham quan theo chủ đề.
          </p>

          <div
            style="
              display: flex;
              flex-wrap: wrap;
              gap: 12px;
              margin-top: 24px;
            "
          >
            <RouterLink
              class="button"
              to="/tham-quan-360"
            >
              Bắt đầu tham quan 360°
            </RouterLink>

            <RouterLink
              class="button button--secondary"
              to="/tour/1"
            >
              Xem tour hướng dẫn
            </RouterLink>
          </div>
        </div>

        <div
          class="hero__visual"
          aria-label="Khung minh hoa bao tang ao 360 do"
          role="img"
        ></div>
      </div>

      <section class="section">
        <h2>
          Trải nghiệm chính
        </h2>

        <div class="card-grid">
          <article class="card">
            <h3>
              Không gian 360°
            </h3>

            <p>
              Điều hướng giữa các panorama bằng
              các điểm chuyển cảnh.
            </p>
          </article>

          <article class="card">
            <h3>
              Hotspot hiện vật
            </h3>

            <p>
              Chạm vào hotspot để mở thông tin
              của hiện vật.
            </p>
          </article>

          <article class="card">
            <h3>
              Thuyết minh đa ngôn ngữ
            </h3>

            <p>
              Kết nối audio narration với ngôn ngữ
              mà người tham quan lựa chọn.
            </p>
          </article>

          <article class="card">
            <h3>
              Tour theo chủ đề
            </h3>

            <p>
              Có chế độ tự do và chế độ hướng dẫn
              theo tuyến tham quan.
            </p>
          </article>

          <article class="card">
            <h3>
              Guestbook
            </h3>

            <p>
              Người dùng có thể để lại lời nhắn
              sau chuyến tham quan.
            </p>
          </article>

          <article class="card">
            <h3>
              Bộ sưu tập cá nhân
            </h3>

            <p>
              Lưu các hiện vật yêu thích vào
              collection cá nhân.
            </p>
          </article>
        </div>
      </section>
    </div>
  </section>
</template>
