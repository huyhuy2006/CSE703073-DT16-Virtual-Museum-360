<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  checkAdmin,
  getCurrentUser,
  login,
  logout,
} from '../services/api'

const router = useRouter()

const email = ref('')
const password = ref('')

const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const currentUser = ref(null)
const adminResult = ref(null)

async function loadCurrentUser() {
  try {
    const result = await getCurrentUser()
    currentUser.value = result.user
  } catch {
    currentUser.value = null
  }
}

async function handleLogin() {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''
  adminResult.value = null

  try {
    const result = await login(
      email.value.trim(),
      password.value
    )

    currentUser.value = result.user
    successMessage.value = result.message

    password.value = ''

    await router.push('/')
  } catch (error) {
    const message = error?.response?.data?.message

    errorMessage.value =
      message || 'Dang nhap that bai.'
  } finally {
    loading.value = false
  }
}

async function handleLogout() {
  errorMessage.value = ''
  successMessage.value = ''
  adminResult.value = null

  try {
    const result = await logout()

    currentUser.value = null
    successMessage.value = result.message
  } catch (error) {
    errorMessage.value =
      error?.response?.data?.message ||
      'Dang xuat that bai.'
  }
}

async function handleAdminCheck() {
  errorMessage.value = ''
  adminResult.value = null

  try {
    adminResult.value = await checkAdmin()
  } catch (error) {
    const status = error?.response?.status

    if (status === 403) {
      adminResult.value = {
        message: 'Tai khoan khong co quyen admin.',
        status: 403,
      }
      return
    }

    if (status === 401) {
      adminResult.value = {
        message: 'Chua dang nhap.',
        status: 401,
      }
      return
    }

    errorMessage.value =
      error?.response?.data?.message ||
      'Khong the kiem tra quyen admin.'
  }
}

onMounted(loadCurrentUser)
</script>

<template>
  <section class="login-page">
    <div class="login-card">
      <header class="login-header">
        <p class="eyebrow">
          DT-16 VIRTUAL MUSEUM 360
        </p>

        <h1>Đăng nhập</h1>

        <p>
          Xác thực tài khoản để sử dụng các chức năng cá nhân
          và khu vực quản trị.
        </p>
      </header>

      <form
        class="login-form"
        @submit.prevent="handleLogin"
      >
        <label for="email">
          Email
        </label>

        <input
          id="email"
          v-model="email"
          type="email"
          autocomplete="email"
          placeholder="admin@dt16.local"
          required
        />

        <label for="password">
          Mật khẩu
        </label>

        <input
          id="password"
          v-model="password"
          type="password"
          autocomplete="current-password"
          required
        />

        <button
          type="submit"
          :disabled="loading"
        >
          {{ loading ? 'Đang đăng nhập...' : 'Đăng nhập' }}
        </button>
      </form>

      <p
        v-if="successMessage"
        class="message success"
      >
        {{ successMessage }}
      </p>

      <p
        v-if="errorMessage"
        class="message error"
      >
        {{ errorMessage }}
      </p>

      <div
        v-if="currentUser"
        class="account-panel"
      >
        <h2>Phiên hiện tại</h2>

        <dl>
          <div>
            <dt>ID</dt>
            <dd>{{ currentUser.id }}</dd>
          </div>

          <div>
            <dt>Họ tên</dt>
            <dd>{{ currentUser.name }}</dd>
          </div>

          <div>
            <dt>Email</dt>
            <dd>{{ currentUser.email }}</dd>
          </div>

          <div>
            <dt>Role</dt>
            <dd>{{ currentUser.role }}</dd>
          </div>
        </dl>

        <div class="action-row">
          <button
            type="button"
            @click="handleAdminCheck"
          >
            Kiểm tra quyền Admin
          </button>

          <button
            type="button"
            class="secondary"
            @click="handleLogout"
          >
            Đăng xuất
          </button>
        </div>

        <pre
          v-if="adminResult"
          class="result-box"
        >{{ JSON.stringify(adminResult, null, 2) }}</pre>
      </div>
    </div>
  </section>
</template>

<style scoped>
.login-page {
  min-height: calc(100vh - 120px);
  display: grid;
  place-items: center;
  padding: 32px 20px;
}

.login-card {
  width: min(100%, 520px);
  padding: 32px;
  border: 1px solid var(--border-color, #d8dee9);
  border-radius: 20px;
  background: var(--surface-color, #ffffff);
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.08);
}

.login-header {
  margin-bottom: 28px;
}

.eyebrow {
  margin: 0 0 8px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.login-header h1 {
  margin: 0 0 10px;
}

.login-header p {
  margin: 0;
  line-height: 1.6;
}

.login-form {
  display: grid;
  gap: 10px;
}

.login-form label {
  font-weight: 600;
  margin-top: 6px;
}

.login-form input {
  width: 100%;
  padding: 12px 14px;
  border: 1px solid var(--border-color, #d8dee9);
  border-radius: 10px;
  background: transparent;
  color: inherit;
  box-sizing: border-box;
}

.login-form button,
.action-row button {
  margin-top: 10px;
  padding: 12px 16px;
  border: 0;
  border-radius: 10px;
  cursor: pointer;
  font-weight: 700;
}

.login-form button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.message {
  margin: 18px 0 0;
  padding: 12px 14px;
  border-radius: 10px;
}

.success {
  border: 1px solid #78c091;
}

.error {
  border: 1px solid #d77a7a;
}

.account-panel {
  margin-top: 28px;
  padding-top: 24px;
  border-top: 1px solid var(--border-color, #d8dee9);
}

.account-panel h2 {
  margin-top: 0;
}

.account-panel dl {
  display: grid;
  gap: 12px;
}

.account-panel dl > div {
  display: grid;
  grid-template-columns: 120px 1fr;
  gap: 12px;
}

.account-panel dt {
  font-weight: 700;
}

.account-panel dd {
  margin: 0;
  word-break: break-word;
}

.action-row {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.secondary {
  opacity: 0.85;
}

.result-box {
  margin-top: 16px;
  padding: 14px;
  overflow-x: auto;
  border-radius: 10px;
  background: rgba(0, 0, 0, 0.05);
}
</style>
