<script setup>
import ThemeToggle from './components/ThemeToggle.vue'
</script>

<template>
  <a
    class="skip-link"
    href="#main-content"
  >
    Bo qua dieu huong
  </a>

  <header class="site-header">
    <div class="container site-header__inner">
      <RouterLink
        class="brand"
        to="/"
      >
        DT-16 Virtual Museum
      </RouterLink>

      <nav
        class="nav"
        aria-label="Dieu huong chinh"
      >
        <RouterLink to="/">
          Trang chu
        </RouterLink>

        <RouterLink to="/tham-quan-360">
          Tham quan 360°
        </RouterLink>

        <RouterLink to="/tour/1">
          Tour chu de
        </RouterLink>

        <ThemeToggle />
      </nav>
    </div>
  </header>

  <main id="main-content">
    <RouterView />
  </main>

  <footer class="site-footer">
    <div class="container">
      <p>
        DT-16 — Bao tang ao va tour tham quan 360 do
        tren nen web
      </p>

      <p>
        Vue 3 + Vite | Laravel 11 | MySQL 8 | FastAPI
      </p>
    </div>
  </footer>
</template>
