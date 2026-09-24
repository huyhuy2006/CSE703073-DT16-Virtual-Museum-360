<script setup>
import { computed, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api, { getStoredUser } from '../services/api';

const route = useRoute();
const router = useRouter();

const session = ref(null);
const booking = ref(null);
const quantity = ref(1);

const loading = ref(false);
const actionLoading = ref(false);
const errorMessage = ref('');
const successMessage = ref('');

const isLoggedIn = computed(() => {
  return Boolean(localStorage.getItem('dt16_token'));
});

function formatDate(value) {
  if (!value) {
    return '';
  }

  return new Date(value).toLocaleString('vi-VN');
}

async function loadSession() {
  loading.value = true;
  errorMessage.value = '';

  try {
    const response = await api.get(
      `/tour-sessions/${route.params.sessionId}`
    );

    session.value = response.data.data;
  } catch (error) {
    errorMessage.value =
      error.response?.data?.message
      || 'Không tải được ca tham quan.';
  } finally {
    loading.value = false;
  }
}

async function createHold() {
  if (!isLoggedIn.value) {
    await router.push('/login');
    return;
  }

  actionLoading.value = true;
  errorMessage.value = '';
  successMessage.value = '';

  try {
    const response = await api.post('/bookings', {
      tour_session_id: Number(route.params.sessionId),
      quantity: Number(quantity.value),
    });

    booking.value = response.data.data;
    successMessage.value = response.data.message;

    await loadSession();
  } catch (error) {
    errorMessage.value =
      error.response?.data?.message
      || 'Không thể giữ chỗ.';
  } finally {
    actionLoading.value = false;
  }
}

async function confirmBooking() {
  if (!booking.value) {
    return;
  }

  actionLoading.value = true;
  errorMessage.value = '';
  successMessage.value = '';

  try {
    const response = await api.post(
      `/bookings/${booking.value.id}/confirm`
    );

    booking.value = response.data.data;
    successMessage.value = response.data.message;

    await loadSession();
  } catch (error) {
    errorMessage.value =
      error.response?.data?.message
      || 'Không thể xác nhận đặt chỗ.';
  } finally {
    actionLoading.value = false;
  }
}

async function cancelBooking() {
  if (!booking.value) {
    return;
  }

  actionLoading.value = true;
  errorMessage.value = '';
  successMessage.value = '';

  try {
    const response = await api.post(
      `/bookings/${booking.value.id}/cancel`
    );

    booking.value = response.data.data;
    successMessage.value = response.data.message;

    await loadSession();
  } catch (error) {
    errorMessage.value =
      error.response?.data?.message
      || 'Không thể hủy đặt chỗ.';
  } finally {
    actionLoading.value = false;
  }
}

onMounted(() => {
  if (!getStoredUser()) {
    router.push('/login');
    return;
  }

  loadSession();
});
</script>

<template>
  <main class="booking-page">
    <section v-if="loading">
      <p>Đang tải ca tham quan...</p>
    </section>

    <section
      v-else-if="session"
      class="booking-layout"
    >
      <article class="session-panel">
        <p class="eyebrow">ĐẶT CHỖ TOUR 360°</p>

        <h1>
          {{ session.tour_name }}
        </h1>

        <p class="code">
          {{ session.session_code }}
        </p>

        <dl>
          <div>
            <dt>Bắt đầu</dt>
            <dd>{{ formatDate(session.starts_at) }}</dd>
          </div>

          <div>
            <dt>Kết thúc</dt>
            <dd>{{ formatDate(session.ends_at) }}</dd>
          </div>

          <div>
            <dt>Sức chứa</dt>
            <dd>{{ session.capacity }}</dd>
          </div>

          <div>
            <dt>Còn chỗ</dt>
            <dd>{{ session.available_seats }}</dd>
          </div>
        </dl>

        <button
          type="button"
          class="back-button"
          @click="router.push('/tour-sessions')"
        >
          ← Quay lại danh sách
        </button>
      </article>

      <article class="booking-panel">
        <h2>Thông tin đặt chỗ</h2>

        <label for="quantity">
          Số khách
        </label>

        <input
          id="quantity"
          v-model.number="quantity"
          type="number"
          min="1"
          max="5"
          :max="Math.min(5, Number(session.available_seats))"
        />

        <button
          type="button"
          :disabled="
            actionLoading
            || Number(session.available_seats) <= 0
          "
          @click="createHold"
        >
          {{
            actionLoading
              ? 'Đang xử lý...'
              : 'Giữ chỗ 15 phút'
          }}
        </button>

        <p
          v-if="successMessage"
          class="success"
        >
          {{ successMessage }}
        </p>

        <p
          v-if="errorMessage"
          class="error"
        >
          {{ errorMessage }}
        </p>

        <div
          v-if="booking"
          class="booking-result"
        >
          <h3>Phiếu đặt chỗ</h3>

          <p>
            <strong>Mã:</strong>
            {{ booking.booking_code }}
          </p>

          <p>
            <strong>Trạng thái:</strong>
            {{ booking.status }}
          </p>

          <p v-if="booking.expires_at">
            <strong>Hết hạn:</strong>
            {{ formatDate(booking.expires_at) }}
          </p>

          <div class="actions">
            <button
              v-if="booking.status === 'pending_payment'"
              type="button"
              @click="confirmBooking"
              :disabled="actionLoading"
            >
              Xác nhận đặt chỗ
            </button>

            <button
              v-if="
                booking.status === 'pending_payment'
                || booking.status === 'confirmed'
              "
              type="button"
              class="danger"
              @click="cancelBooking"
              :disabled="actionLoading"
            >
              Hủy đặt chỗ
            </button>
          </div>
        </div>
      </article>
    </section>

    <p v-else>
      Không tìm thấy ca tham quan.
    </p>
  </main>
</template>

<style scoped>
.booking-page {
  max-width: 1100px;
  margin: 0 auto;
  padding: 32px 16px 56px;
}

.booking-layout {
  display: grid;
  grid-template-columns: 1.2fr 0.8fr;
  gap: 24px;
}

.session-panel,
.booking-panel {
  padding: 28px;
  border: 1px solid #e4e7ec;
  border-radius: 18px;
  background: #fff;
}

.eyebrow {
  margin: 0 0 8px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.12em;
}

h1 {
  margin: 0 0 8px;
  font-size: 32px;
}

.code {
  margin: 0 0 24px;
  font-weight: 700;
}

dl {
  display: grid;
  gap: 14px;
}

dl div {
  display: flex;
  justify-content: space-between;
  gap: 16px;
}

dt {
  font-weight: 600;
}

dd {
  margin: 0;
  text-align: right;
}

.booking-panel {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.booking-panel h2 {
  margin: 0 0 8px;
}

.booking-panel input {
  padding: 12px;
  border: 1px solid #d0d5dd;
  border-radius: 10px;
}

button {
  border: 0;
  border-radius: 10px;
  padding: 12px 14px;
  font: inherit;
  font-weight: 700;
  cursor: pointer;
}

button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.back-button {
  margin-top: 24px;
}

.booking-result {
  margin-top: 12px;
  padding: 16px;
  border-radius: 12px;
  background: #f9fafb;
}

.actions {
  display: grid;
  gap: 10px;
  margin-top: 14px;
}

.danger {
  color: #b42318;
}

.success {
  color: #027a48;
}

.error {
  color: #b42318;
}

@media (max-width: 800px) {
  .booking-layout {
    grid-template-columns: 1fr;
  }
}
</style>
