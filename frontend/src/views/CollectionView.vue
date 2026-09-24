<script setup>
import { ref } from 'vue'

const collection = ref([
  {
    title: 'Hiện vật yêu thích 01',
    description:
      'Bản ghi giao diện mẫu cho bộ sưu tập cá nhân.',
    savedAt: '24/09/2026',
  },
  {
    title: 'Không gian đã đánh dấu',
    description:
      'Khu vực được lưu lại để tiếp tục khám phá.',
    savedAt: '24/09/2026',
  },
])
</script>

<template>
  <section class="page-section">
    <div class="container">
      <span class="eyebrow">
        Personal Collection
      </span>

      <h1
        class="section-heading"
        style="margin-top: 12px;"
      >
        Bộ sưu tập cá nhân
      </h1>

      <p class="section-description">
        Giao diện cho phép người dùng lưu lại hiện vật
        và không gian muốn khám phá lại.
      </p>

      <div
        v-if="collection.length"
        class="collection-list"
      >
        <article
          v-for="item in collection"
          :key="`${item.title}-${item.savedAt}`"
          class="the collection-item"
        >
          <div>
            <span class="badge">
              Đã lưu
            </span>

            <h2
              class="the-tieu-de"
              style="margin-top: 10px;"
            >
              {{ item.title }}
            </h2>

            <p class="the-mo-ta">
              {{ item.description }}
            </p>

            <small
              style="
                display: block;
                margin-top: 10px;
                color: var(--mau-chu-muted);
              "
            >
              Lưu lúc: {{ item.savedAt }}
            </small>
          </div>
        </article>
      </div>

      <div
        v-else
        class="the empty-state"
      >
        Chưa có nội dung nào trong bộ sưu tập.
      </div>
    </div>
  </section>
</template>
