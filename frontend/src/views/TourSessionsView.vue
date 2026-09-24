<script setup>
import { onMounted, reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import api from '../services/api';

const router = useRouter();

const tours = ref([]);
const sessions = ref([]);
const loading = ref(false);
const errorMessage = ref('');

const pagination = reactive({
  currentPage: 1,
  lastPage: 1,
  total: 0,
  perPage: 10,
});

const filters = reactive({
  keyword: '',
  tourId: '',
  dateFrom: '',
  dateTo: '',
  availableOnly: true,
});

async function loadTours() {
  try {
    const response = await api.get('/tours');

    tours.value = Array.isArray(response.data)
      ? response.data
      : (response.data.data || []);
  } catch {
    tours.value = [];
  }
}

async function loadSessions(page = 1) {
  loading.value = true;
  errorMessage.value = '';

  try {
    const params = {
      page,
      per_page: pagination.perPage,
    };

    if (filters.keyword.trim()) {
      params.keyword = filters.keyword.trim();
    }

    if (filters.tourId) {
      params.tour_id = filters.tourId;
    }

    if (filters.dateFrom) {
      params.date_from = filters.dateFrom;
    }

    if (filters.dateTo) {
      params.date_to = filters.dateTo;
    }

    if (filters.availableOnly) {
      params.available_only = 1;
    }

    const response = await api.get('/tour-sessions', {
      params,
    });

    sessions.value = response.data.data || [];

    pagination.currentPage =
      response.data.current_page || 1;

    pagination.lastPage =
      response.data.last_page || 1;

    pagination.total =
      response.data.total || 0;
  } catch (error) {
    errorMessage.value =
      error.response?.data?.message
      || 'Không tải được danh sách ca tham quan.';
  } finally {
    loading.value = false;
  }
}

function search() {
  loadSessions(1);
}

function openBooking(sessionId) {
  router.push(`/booking/${sessionId}`);
}

function formatDate(value) {
  if (!value) {
    return '';
  }

  return new Date(value).toLocaleString('vi-VN');
}

onMounted(async () => {
  await loadTours();
  await loadSessions(1);
});
</script>

<template>
  <main class="catalog-page">
    <section class="hero">
      <p class="eyebrow">DT-16 · M2</p>
      <h1>Ca tham quan có hướng dẫn</h1>
      <p>
        Tìm kiếm và đặt chỗ cho các phiên tour tham quan
        bảo tàng ảo.
      </p>
    </section>

    <section class="filters">
      <input
        v-model="filters.keyword"
        type="search"
        placeholder="Tìm tour hoặc mã ca..."
        @keyup.enter="search"
      />

      <select v-model="filters.tourId">
        <option value="">Tất cả tour</option>
        <option
          v-for="tour in tours"
          :key="tour.id"
          :value="tour.id"
        >
          {{ tour.name }}
        </option>
      </select>

      <label>
        Từ ngày
        <input
          v-model="filters.dateFrom"
          type="date"
        />
      </label>

      <label>
        Đến ngày
        <input
          v-model="filters.dateTo"
          type="date"
        />
      </label>

      <label class="checkbox-label">
        <input
          v-model="filters.availableOnly"
          type="checkbox"
        />
        Chỉ hiển thị còn chỗ
      </label>

      <button type="button" @click="search">
        Tìm kiếm
      </button>
    </section>

    <p v-if="errorMessage" class="error">
      {{ errorMessage }}
    </p>

    <p class="result-count">
      Tổng số ca: {{ pagination.total }}
    </p>

    <section class="session-grid">
      <article
        v-for="item in sessions"
        :key="item.id"
        class="session-card"
      >
        <div class="session-code">
          {{ item.session_code }}
        </div>

        <h2>
          {{ item.tour_name }}
        </h2>

        <p>
          <strong>Bắt đầu:</strong>
          {{ formatDate(item.starts_at) }}
        </p>

        <p>
          <strong>Kết thúc:</strong>
          {{ formatDate(item.ends_at) }}
        </p>

        <p>
          <strong>Sức chứa:</strong>
          {{ item.capacity }}
        </p>

        <p>
          <strong>Còn lại:</strong>
          {{ item.available_seats }}
        </p>

        <button
          type="button"
          :disabled="Number(item.available_seats) <= 0"
          @click="openBooking(item.id)"
        >
          {{
            Number(item.available_seats) > 0
              ? 'Đặt chỗ'
              : 'Hết chỗ'
          }}
        </button>
      </article>
    </section>

    <nav
      v-if="pagination.lastPage > 1"
      class="pagination"
    >
      <button
        type="button"
        :disabled="pagination.currentPage <= 1"
        @click="loadSessions(pagination.currentPage - 1)"
      >
        ← Trước
      </button>

      <span>
        Trang {{ pagination.currentPage }}
        /
        {{ pagination.lastPage }}
      </span>

      <button
        type="button"
        :disabled="
          pagination.currentPage >= pagination.lastPage
        "
        @click="loadSessions(pagination.currentPage + 1)"
      >
        Sau →
      </button>
    </nav>
  </main>
</template>

<style scoped>
.catalog-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 32px 16px 56px;
}

.hero {
  margin-bottom: 24px;
}

.eyebrow {
  margin: 0 0 6px;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.12em;
}

h1 {
  margin: 0 0 8px;
  font-size: 34px;
}

.hero p:last-child {
  margin: 0;
  color: #667085;
}

.filters {
  display: grid;
  grid-template-columns:
    minmax(220px, 2fr)
    minmax(180px, 1fr)
    minmax(130px, 1fr)
    minmax(130px, 1fr);
  gap: 12px;
  padding: 18px;
  border: 1px solid #e4e7ec;
  border-radius: 16px;
  margin-bottom: 24px;
}

.filters input,
.filters select {
  width: 100%;
  box-sizing: border-box;
  padding: 11px 12px;
  border: 1px solid #d0d5dd;
  border-radius: 10px;
  font: inherit;
}

.filters label {
  display: grid;
  gap: 6px;
  font-size: 13px;
  font-weight: 600;
}

.checkbox-label {
  display: flex !important;
  align-items: center;
  gap: 8px !important;
}

.checkbox-label input {
  width: auto;
}

.filters button,
.session-card button,
.pagination button {
  border: 0;
  border-radius: 10px;
  padding: 11px 14px;
  font: inherit;
  font-weight: 700;
  cursor: pointer;
}

.filters button {
  grid-column: 1 / -1;
}

.result-count {
  margin-bottom: 16px;
  color: #667085;
}

.session-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px;
}

.session-card {
  padding: 20px;
  border: 1px solid #e4e7ec;
  border-radius: 16px;
  background: #fff;
}

.session-code {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.session-card h2 {
  margin: 10px 0 14px;
  font-size: 20px;
}

.session-card p {
  margin: 8px 0;
}

.session-card button {
  width: 100%;
  margin-top: 12px;
}

.session-card button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 28px;
}

.error {
  margin: 16px 0;
  color: #b42318;
}

@media (max-width: 900px) {
  .filters {
    grid-template-columns: 1fr 1fr;
  }

  .session-grid {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 640px) {
  .filters {
    grid-template-columns: 1fr;
  }

  .session-grid {
    grid-template-columns: 1fr;
  }
}
</style>
