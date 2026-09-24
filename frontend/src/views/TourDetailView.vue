<script setup>
import { RouterLink } from 'vue-router'

const tours = [
  {
    id: 1,
    title: 'Hành trình khám phá bảo tàng',
    mode: 'Có hướng dẫn',
    stops: 4,
    duration: 'Khoảng 20 phút',
    description:
      'Tuyến tham quan kể chuyện từ không gian mở đầu đến các hiện vật nổi bật.',
  },
  {
    id: 2,
    title: 'Dấu ấn hiện vật',
    mode: 'Tự do',
    stops: 6,
    duration: 'Khoảng 30 phút',
    description:
      'Tuyến tập trung vào các điểm thông tin hiện vật và lớp nội dung chuyên sâu.',
  },
  {
    id: 3,
    title: 'Tour trải nghiệm 360°',
    mode: 'Có hướng dẫn',
    stops: 5,
    duration: 'Khoảng 25 phút',
    description:
      'Tuyến kết hợp chuyển cảnh không gian, hotspot và thuyết minh.',
  },
]
</script>

<template>
  <section class="page-section">
    <div class="container">
      <span class="eyebrow">
        Themed Tours
      </span>

      <h1
        class="section-heading"
        style="margin-top: 12px;"
      >
        Tour tham quan theo chủ đề
      </h1>

      <p class="section-description">
        Người dùng có thể lựa chọn cách tham quan tự do
        hoặc theo tuyến được xây dựng sẵn.
      </p>

      <div class="tour-list">
        <article
          v-for="tour in tours"
          :key="tour.id"
          class="the tour-card"
        >
          <div>
            <div class="tour-card-meta">
              <span class="badge">
                {{ tour.mode }}
              </span>

              <span class="badge">
                {{ tour.stops }} điểm dừng
              </span>

              <span class="badge">
                {{ tour.duration }}
              </span>
            </div>

            <h2
              class="the-tieu-de"
              style="margin-top: 14px;"
            >
              {{ tour.title }}
            </h2>

            <p class="the-mo-ta">
              {{ tour.description }}
            </p>
          </div>

          <div class="tour-card-actions">
            <RouterLink
              class="nut nut-chinh"
              to="/museum-360"
            >
              Bắt đầu tour
            </RouterLink>

            <button
              class="nut nut-phu"
              type="button"
            >
              Xem lộ trình
            </button>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>
