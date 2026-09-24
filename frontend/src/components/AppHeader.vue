<script setup>
import { ref } from 'vue'
import { RouterLink } from 'vue-router'
import ThemeToggle from './ThemeToggle.vue'

const menuOpen = ref(false)

function closeMenu() {
  menuOpen.value = false
}
</script>

<template>
  <header class="app-header">
    <div class="container app-header-inner">
      <RouterLink
        class="brand"
        to="/"
        aria-label="Bảo tàng ảo 360 - Trang chủ"
        @click="closeMenu"
      >
        <span class="brand-mark" aria-hidden="true">360</span>

        <span class="brand-text">
          <strong>Bảo tàng ảo 360°</strong>
          <small>ĐT-16</small>
        </span>
      </RouterLink>

      <button
        class="mobile-menu-button"
        type="button"
        :aria-expanded="menuOpen"
        aria-controls="main-navigation"
        @click="menuOpen = !menuOpen"
      >
        <span aria-hidden="true">
          {{ menuOpen ? '✕' : '☰' }}
        </span>

        <span class="sr-only">
          {{ menuOpen ? 'Đóng menu' : 'Mở menu' }}
        </span>
      </button>

      <nav
        id="main-navigation"
        class="main-navigation"
        :class="{ 'is-open': menuOpen }"
        aria-label="Điều hướng chính"
      >
        <RouterLink
          class="nav-link"
          to="/"
          @click="closeMenu"
        >
          Trang chủ
        </RouterLink>

        <RouterLink
          class="nav-link"
          to="/museum-360"
          @click="closeMenu"
        >
          Tham quan 360°
        </RouterLink>

        <RouterLink
          class="nav-link"
          to="/tours"
          @click="closeMenu"
        >
          Tour chủ đề
        </RouterLink>

        <RouterLink
          class="nav-link"
          to="/collection"
          @click="closeMenu"
        >
          Bộ sưu tập
        </RouterLink>

        <RouterLink
          class="nav-link"
          to="/guestbook"
          @click="closeMenu"
        >
          Lưu bút
        </RouterLink>

        <ThemeToggle />
      </nav>
    </div>
  </header>
</template>

<style scoped>
.app-header {
  position: sticky;
  z-index: 100;
  top: 0;
  border-bottom: 1px solid var(--mau-vien);
  background: color-mix(
    in srgb,
    var(--mau-nen-phu) 94%,
    transparent
  );
  backdrop-filter: blur(12px);
}

.app-header-inner {
  min-height: var(--header-height);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  color: inherit;
  text-decoration: none;
}

.brand-mark {
  display: grid;
  width: 42px;
  height: 42px;
  place-items: center;
  border-radius: 12px;
  background: var(--mau-chinh);
  color: #ffffff;
  font-size: 12px;
  font-weight: 900;
}

.brand-text {
  display: grid;
  gap: 0;
}

.brand-text strong {
  font-size: 15px;
}

.brand-text small {
  color: var(--mau-chu-muted);
  font-size: 12px;
}

.main-navigation {
  display: none;
  align-items: center;
  gap: 8px;
}

.main-navigation.is-open {
  position: absolute;
  top: calc(var(--header-height) + 1px);
  left: 0;
  right: 0;
  display: grid;
  padding: 14px;
  border-bottom: 1px solid var(--mau-vien);
  background: var(--mau-nen-phu);
  box-shadow: var(--do-bong);
}

.nav-link {
  min-height: 44px;
  display: inline-flex;
  align-items: center;
  padding: 10px 12px;
  border-radius: 10px;
  color: var(--mau-chu-nhat);
  text-decoration: none;
  font-weight: 700;
}

.nav-link:hover,
.nav-link.router-link-active {
  background: var(--mau-nen-alt);
  color: var(--mau-chinh-dam);
}

.mobile-menu-button {
  min-width: 44px;
  min-height: 44px;
  border: 1px solid var(--mau-vien);
  border-radius: 10px;
  background: var(--mau-nen-phu);
  color: var(--mau-chu);
  cursor: pointer;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  border: 0;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
}

@media (min-width: 1024px) {
  .main-navigation {
    display: flex;
  }

  .mobile-menu-button {
    display: none;
  }
}
</style>
