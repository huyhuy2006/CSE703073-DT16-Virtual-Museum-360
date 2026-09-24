<script setup>
import { RouterLink } from 'vue-router'
</script>

<template>
  <section class="page-section">
    <div class="container">
      <div
        class="the empty-state"
        style="max-width: 720px; margin: 0 auto;"
      >
        <span class="eyebrow">
          404
        </span>

        <h1
          class="section-heading"
          style="margin-top: 16px;"
        >
          Không tìm thấy trang
        </h1>

        <p class="section-description" style="margin-inline: auto;">
          Đường dẫn bạn truy cập không tồn tại trong
          hệ thống bảo tàng ảo.
        </p>

        <RouterLink
          class="nut nut-chinh"
          to="/"
        >
          Về trang chủ
        </RouterLink>
      </div>
    </div>
  </section>
</template>
