<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import api from '../services/api';

const router = useRouter();

const email = ref('');
const password = ref('');
const loading = ref(false);
const errorMessage = ref('');

async function submitLogin() {
  errorMessage.value = '';

  if (!email.value || !password.value) {
    errorMessage.value = 'Vui lÃ²ng nháº­p Ä‘áº§y Ä‘á»§ email vÃ  máº­t kháº©u.';
    return;
  }

  loading.value = true;

  try {
    const response = await api.post('/auth/login', {
      email: email.value.trim(),
      password: password.value,
    });

    localStorage.setItem('dt16_token', response.data.token);
    localStorage.setItem(
      'dt16_user',
      JSON.stringify(response.data.user)
    );

    await router.push('/tour-sessions');
  } catch (error) {
    errorMessage.value =
      error.response?.data?.message
      || 'ÄÄƒng nháº­p tháº¥t báº¡i.';
  } finally {
    loading.value = false;
  }
}
</script>

<template>
  <main class="login-page">
    <section class="login-card">
      <div class="login-header">
        <p class="eyebrow">DT-16</p>
        <h1>ÄÄƒng nháº­p</h1>
        <p>
          Báº£o tÃ ng áº£o vÃ  tour tham quan 360Â°
        </p>
      </div>

      <form @submit.prevent="submitLogin">
        <label for="email">Email</label>
        <input
          id="email"
          v-model="email"
          type="email"
          autocomplete="username"
          placeholder="Nháº­p email"
        />

        <label for="password">Máº­t kháº©u</label>
        <input
          id="password"
          v-model="password"
          type="password"
          autocomplete="current-password"
          placeholder="Nháº­p máº­t kháº©u"
        />

        <p
          v-if="errorMessage"
          class="error-message"
        >
          {{ errorMessage }}
        </p>

        <button
          type="submit"
          :disabled="loading"
        >
          {{ loading ? 'Äang Ä‘Äƒng nháº­p...' : 'ÄÄƒng nháº­p' }}
        </button>
      </form>
    </section>
  </main>
</template>

<style scoped>
.login-page {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 32px 16px;
  background: #f4f6f8;
}

.login-card {
  width: min(440px, 100%);
  padding: 32px;
  border-radius: 18px;
  background: #ffffff;
  box-shadow: 0 16px 50px rgba(0, 0, 0, 0.08);
}

.login-header {
  margin-bottom: 24px;
}

.eyebrow {
  margin: 0 0 8px;
  font-weight: 700;
  letter-spacing: 0.12em;
}

h1 {
  margin: 0 0 8px;
  font-size: 30px;
}

.login-header p:last-child {
  margin: 0;
  color: #667085;
}

form {
  display: grid;
  gap: 10px;
}

label {
  margin-top: 8px;
  font-weight: 600;
}

input {
  width: 100%;
  box-sizing: border-box;
  padding: 12px 14px;
  border: 1px solid #d0d5dd;
  border-radius: 10px;
  font: inherit;
}

button {
  margin-top: 14px;
  border: 0;
  border-radius: 10px;
  padding: 12px 16px;
  font: inherit;
  font-weight: 700;
  cursor: pointer;
}

button:disabled {
  cursor: not-allowed;
  opacity: 0.6;
}

.error-message {
  margin: 8px 0 0;
  color: #b42318;
}
</style>

