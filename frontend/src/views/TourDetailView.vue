<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
  tourId: {
    type: [String, Number],
    default: 1,
  },
})

const mode = ref('guided')

const stops = [
  {
    order: 1,
    spaceId: 1,
    title: 'Không gian mở đầu',
    description:
      'Giới thiệu bối cảnh lịch sử của không gian.',
  },
  {
    order: 2,
    spaceId: 2,
    title: 'Khu vực hiện vật tiêu biểu',
    description:
      'Khám phá các hiện vật được gắn hotspot.',
  },
  {
    order: 3,
    spaceId: 3,
    title: 'Không gian kết thúc',
    description:
      'Tổng kết nội dung và chuyển sang bộ sưu tập.',
  },
]

const modeLabel = computed(() =>
  mode.value === 'guided'
    ? 'Có hướng dẫn'
    : 'Tự do',
)
</script>

<template>
  <section class="page">
    <div class="container">
      <header>
        <span class="badge">
          TOUR #{{ props.tourId }}
        </span>

        <h1>
          Hành trình di sản
        </h1>

        <p class="hero__text">
          Tour theo chủ đề kết hợp panorama 360°,
          hotspot hiện vật và thuyết minh đa ngôn ngữ.
        </p>
      </header>

      <section class="section">
        <div class="card">
          <h2>
            Chế độ tham quan
          </h2>

          <div
            style="
              display: flex;
              gap: 12px;
              flex-wrap: wrap;
            "
          >
            <button
              class="button"
              type="button"
              @click="mode = 'guided'"
            >
              Có hướng dẫn
            </button>

            <button
              class="button button--secondary"
              type="button"
              @click="mode = 'free'"
            >
              Tự do
            </button>
          </div>

          <p style="margin-top: 12px">
            Chế độ hiện tại:
            <strong>
              {{ modeLabel }}
            </strong>
          </p>
        </div>
      </section>

      <section class="section">
        <div class="tour-layout">
          <aside class="card">
            <h2>
              Lộ trình
            </h2>

            <div class="stop-list">
              <div
                v-for="stop in stops"
                :key="stop.order"
                class="stop"
              >
                <strong>
                  Điểm {{ stop.order }}
                </strong>

                <div>
                  {{ stop.title }}
                </div>
              </div>
            </div>
          </aside>

          <main>
            <div class="viewer">
              <div class="viewer__placeholder">
                <h2>
                  Không gian 360° của điểm hiện tại
                </h2>

                <p>
                  Panorama, hotspot và audio narration
                  sẽ được kết nối API tại bước triển khai
                  chức năng.
                </p>
              </div>
            </div>

            <div class="section">
              <div
                v-for="stop in stops"
                :key="`${stop.order}-detail`"
                class="card"
                style="margin-bottom: 12px"
              >
                <span class="badge">
                  Stop {{ stop.order }}
                </span>

                <h3>
                  {{ stop.title }}
                </h3>

                <p>
                  {{ stop.description }}
                </p>

                <RouterLink
                  class="button"
                  to="/tham-quan-360"
                >
                  Mở tham quan 360°
                </RouterLink>
              </div>
            </div>
          </main>
        </div>
      </section>
    </div>
  </section>
</template>
