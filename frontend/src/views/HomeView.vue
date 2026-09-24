<script setup>
import { RouterLink } from 'vue-router'

const highlights = [
  {
    title: 'Không gian bảo tàng',
    description:
      'Khám phá các không gian được tổ chức thành tuyến tham quan số.',
  },
  {
    title: 'Hiện vật tương tác',
    description:
      'Các điểm thông tin trong không gian giúp người xem tiếp cận lớp kiến thức của hiện vật.',
  },
  {
    title: 'Tour theo chủ đề',
    description:
      'Lựa chọn tuyến tham quan theo nội dung và cách kể chuyện.',
  },
]

const stats = [
  {
    value: '360°',
    label: 'Trải nghiệm panorama',
  },
  {
    value: '2',
    label: 'Chủ đề giao diện',
  },
  {
    value: '3',
    label: 'Khổ màn hình',
  },
]
</script>

<template>
  <section class="hero">
    <div class="container hero-grid">
      <div>
        <span class="eyebrow">
          ĐT-16 · Virtual Museum
        </span>

        <h1 class="hero-title">
          Bảo tàng ảo
          <br />
          và tour tham quan 360°
        </h1>

        <p class="hero-description">
          Một không gian bảo tàng số trên nền web,
          kết hợp hình ảnh panorama 360°, điểm thông tin
          hiện vật, tuyến tham quan theo chủ đề và trải nghiệm
          khám phá linh hoạt.
        </p>

        <div class="hero-actions">
          <RouterLink
            class="nut nut-chinh"
            to="/museum-360"
          >
            Bắt đầu tham quan 360°
          </RouterLink>

          <RouterLink
            class="nut nut-phu"
            to="/tours"
          >
            Xem tour chủ đề
          </RouterLink>
        </div>

        <div class="info-strip">
          <article
            v-for="item in stats"
            :key="item.label"
            class="info-item"
          >
            <span class="info-value">
              {{ item.value }}
            </span>

            <span class="info-label">
              {{ item.label }}
            </span>
          </article>
        </div>
      </div>

      <div class="the hero-panel">
        <div class="hero-panel-top">
          <strong>
            Trải nghiệm không gian số
          </strong>
        </div>

        <div class="hero-panel-body">
          <div style="text-align: center;">
            <div class="eyebrow">
              Panorama 360°
            </div>

            <div
              style="
                margin: 18px auto;
                width: 180px;
                height: 180px;
                border-radius: 50%;
                display: grid;
                place-items: center;
                background:
                  radial-gradient(
                    circle at 35% 30%,
                    var(--mau-chinh),
                    var(--mau-chinh-dam)
                  );
                color: #fff;
                font-size: 42px;
                font-weight: 900;
              "
            >
              360°
            </div>

            <h2 style="margin: 0 0 8px;">
              Đi vào không gian bảo tàng
            </h2>

            <p class="the-mo-ta">
              Giao diện nền đã sẵn sàng để nhận dữ liệu
              panorama từ backend.
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="page-section">
    <div class="container">
      <h2 class="section-heading">
        Trải nghiệm cốt lõi
      </h2>

      <p class="section-description">
        Giao diện được xây dựng xoay quanh đúng bài toán
        bảo tàng ảo và tour 360° của ĐT-16.
      </p>

      <div class="luoi luoi-3">
        <article
          v-for="item in highlights"
          :key="item.title"
          class="the"
        >
          <div class="the-noi-dung">
            <h3 class="the-tieu-de">
              {{ item.title }}
            </h3>

            <p class="the-mo-ta">
              {{ item.description }}
            </p>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>
