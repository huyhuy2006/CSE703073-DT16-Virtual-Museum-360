<script setup>
import { ref } from 'vue'

const name = ref('')
const message = ref('')

const entries = ref([
  {
    name: 'Khách tham quan',
    message:
      'Giao diện lưu bút sẽ được kết nối với guestbook_entries ở backend.',
    date: '24/09/2026',
  },
])

function submitEntry() {
  const cleanName = name.value.trim()
  const cleanMessage = message.value.trim()

  if (!cleanName || !cleanMessage) {
    return
  }

  entries.value.unshift({
    name: cleanName,
    message: cleanMessage,
    date: new Date().toLocaleDateString('vi-VN'),
  })

  name.value = ''
  message.value = ''
}
</script>

<template>
  <section class="page-section">
    <div class="container">
      <span class="eyebrow">
        Guestbook
      </span>

      <h1
        class="section-heading"
        style="margin-top: 12px;"
      >
        Lưu bút tham quan
      </h1>

      <p class="section-description">
        Không gian để khách tham quan để lại nhận xét
        và cảm nhận sau hành trình khám phá bảo tàng.
      </p>

      <div class="luoi luoi-2">
        <section class="the">
          <div class="the-noi-dung">
            <h2 class="the-tieu-de">
              Viết lưu bút
            </h2>

            <form
              style="display: grid; gap: 16px; margin-top: 18px;"
              @submit.prevent="submitEntry"
            >
              <label class="form-field">
                <span class="form-label">
                  Tên hiển thị
                </span>

                <input
                  v-model="name"
                  class="form-input"
                  type="text"
                  maxlength="100"
                  autocomplete="name"
                  placeholder="Nhập tên của bạn"
                />
              </label>

              <label class="form-field">
                <span class="form-label">
                  Nội dung
                </span>

                <textarea
                  v-model="message"
                  class="form-input"
                  rows="6"
                  maxlength="1000"
                  placeholder="Chia sẻ cảm nhận của bạn"
                ></textarea>
              </label>

              <button
                class="nut nut-chinh"
                type="submit"
              >
                Gửi lưu bút
              </button>
            </form>
          </div>
        </section>

        <section>
          <div class="guestbook-list">
            <article
              v-for="entry in entries"
              :key="`${entry.name}-${entry.date}-${entry.message}`"
              class="the guestbook-entry"
            >
              <div class="guestbook-entry-header">
                <span class="guestbook-author">
                  {{ entry.name }}
                </span>

                <span class="guestbook-date">
                  {{ entry.date }}
                </span>
              </div>

              <p class="the-mo-ta">
                {{ entry.message }}
              </p>
            </article>
          </div>
        </section>
      </div>
    </div>
  </section>
</template>
