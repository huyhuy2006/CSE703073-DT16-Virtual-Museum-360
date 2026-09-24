<script setup>
defineProps({
  title: {
    type: String,
    default: 'Không gian bảo tàng 360°',
  },
  description: {
    type: String,
    default:
      'Khu vực hiển thị ảnh panorama 360° và các điểm tương tác.',
  },
})
</script>

<template>
  <section class="panorama-shell">
    <div class="panorama-toolbar">
      <div class="panorama-toolbar-group">
        <span class="badge">
          360° Panorama
        </span>

        <span class="badge">
          Preview
        </span>
      </div>
    </div>

    <div class="panorama-viewport">
      <div class="panorama-fallback">
        <div class="eyebrow">
          Không gian số
        </div>

        <h2 style="margin: 12px 0 8px;">
          {{ title }}
        </h2>

        <p style="margin: 0; color: inherit;">
          {{ description }}
        </p>

        <p style="margin: 16px 0 0; opacity: 0.8;">
          Ảnh panorama thực tế sẽ được kết nối từ
          dữ liệu `panoramas` ở bước tích hợp backend.
        </p>
      </div>
    </div>
  </section>
</template>
