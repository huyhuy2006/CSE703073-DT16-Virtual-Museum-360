<script setup>
import PanoramaPreview from '../components/PanoramaPreview.vue'

const spaces = [
  {
    id: 1,
    title: 'Không gian 01',
    description:
      'Điểm bắt đầu của hành trình khám phá bảo tàng ảo.',
  },
  {
    id: 2,
    title: 'Không gian 02',
    description:
      'Khu vực dành cho lớp thông tin và hiện vật tương tác.',
  },
  {
    id: 3,
    title: 'Không gian 03',
    description:
      'Khu vực kết nối tiếp các tuyến tham quan.',
  },
]

const hotspots = [
  {
    title: 'Điểm thông tin hiện vật',
    description:
      'Vị trí này sẽ liên kết tới bảng artifacts và hotspots.',
  },
  {
    title: 'Điểm chuyển không gian',
    description:
      'Vị trí này sẽ liên kết tới bảng space_transitions.',
  },
  {
    title: 'Nội dung thuyết minh',
    description:
      'Vị trí này sẽ liên kết tới audio_narrations theo ngôn ngữ.',
  },
]
</script>

<template>
  <section class="page-section">
    <div class="container">
      <span class="eyebrow">
        Tham quan tự do
      </span>

      <h1 class="section-heading" style="margin-top: 12px;">
        Không gian bảo tàng 360°
      </h1>

      <p class="section-description">
        Đây là giao diện nền cho trải nghiệm panorama,
        hotspot hiện vật, chuyển cảnh và thuyết minh đa ngôn ngữ.
      </p>

      <div style="margin-bottom: 24px;">
        <PanoramaPreview
          title="Không gian bảo tàng 360°"
          description="Khung panorama sẵn sàng nhận ảnh 360° từ backend."
        />
      </div>

      <div class="luoi luoi-3">
        <article
          v-for="space in spaces"
          :key="space.id"
          class="the"
        >
          <div class="the-noi-dung">
            <span class="badge">
              Không gian {{ space.id }}
            </span>

            <h2 class="the-tieu-de" style="margin-top: 12px;">
              {{ space.title }}
            </h2>

            <p class="the-mo-ta">
              {{ space.description }}
            </p>
          </div>
        </article>
      </div>

      <section style="margin-top: 48px;">
        <h2 class="section-heading">
          Điểm tương tác trong panorama
        </h2>

        <div class="hotspot-list">
          <article
            v-for="hotspot in hotspots"
            :key="hotspot.title"
            class="hotspot-item"
          >
            <span class="hotspot-dot" aria-hidden="true"></span>

            <div>
              <strong>
                {{ hotspot.title }}
              </strong>

              <p
                style="
                  margin: 4px 0 0;
                  color: var(--mau-chu-nhat);
                "
              >
                {{ hotspot.description }}
              </p>
            </div>
          </article>
        </div>
      </section>
    </div>
  </section>
</template>
