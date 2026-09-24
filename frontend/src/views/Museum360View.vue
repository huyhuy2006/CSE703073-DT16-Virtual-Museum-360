<script setup>
import { ref } from 'vue'

const selectedSpace = ref(1)
const selectedLanguage = ref(1)

const spaces = [
  {
    id: 1,
    code: 'SPACE-001',
    title: 'Không gian trưng bày 01',
  },
  {
    id: 2,
    code: 'SPACE-002',
    title: 'Không gian trưng bày 02',
  },
  {
    id: 3,
    code: 'SPACE-003',
    title: 'Không gian trưng bày 03',
  },
]
</script>

<template>
  <section class="page">
    <div class="container">
      <header>
        <span class="badge">
          THAM QUAN 360°
        </span>

        <h1>
          Không gian bảo tàng
        </h1>

        <p class="hero__text">
          Khung trình xem panorama 360°,
          hotspot hiện vật và chuyển cảnh
          giữa các không gian.
        </p>
      </header>

      <div class="section">
        <div
          style="
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 16px;
          "
        >
          <label>
            Không gian:

            <select v-model="selectedSpace">
              <option
                v-for="space in spaces"
                :key="space.id"
                :value="space.id"
              >
                {{ space.title }}
              </option>
            </select>
          </label>

          <label>
            Ngôn ngữ:

            <select v-model="selectedLanguage">
              <option :value="1">
                Tiếng Việt
              </option>

              <option :value="2">
                English
              </option>

              <option :value="3">
                Français
              </option>
            </select>
          </label>
        </div>

        <div class="viewer">
          <div class="viewer__placeholder">
            <h2>
              Panorama 360° sẽ hiển thị tại đây
            </h2>

            <p>
              Space đang chọn:
              <strong>
                {{
                  spaces.find(
                    (space) =>
                      space.id === selectedSpace,
                  )?.title
                }}
              </strong>
            </p>

            <p>
              Đây là placeholder cho engine
              panorama thật sẽ tích hợp ở bước
              triển khai chức năng 360°.
            </p>

            <div
              style="
                display: flex;
                justify-content: center;
                gap: 12px;
                flex-wrap: wrap;
                margin-top: 20px;
              "
            >
              <button
                class="button"
                type="button"
              >
                Hotspot hiện vật
              </button>

              <button
                class="button button--secondary"
                type="button"
              >
                Chuyển không gian
              </button>
            </div>
          </div>
        </div>
      </div>

      <section class="section">
        <h2>
          Danh sách không gian
        </h2>

        <div class="card-grid">
          <article
            v-for="space in spaces"
            :key="space.id"
            class="card"
          >
            <span class="badge">
              {{ space.code }}
            </span>

            <h3>
              {{ space.title }}
            </h3>

            <button
              class="button"
              type="button"
              style="margin-top: 12px"
              @click="selectedSpace = space.id"
            >
              Xem không gian
            </button>
          </article>
        </div>
      </section>
    </div>
  </section>
</template>
