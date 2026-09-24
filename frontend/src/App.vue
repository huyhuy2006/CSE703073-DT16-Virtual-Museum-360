<script setup>
import { RouterView } from 'vue-router'
import SkipLink from './components/SkipLink.vue'
import AppHeader from './components/AppHeader.vue'
import AppFooter from './components/AppFooter.vue'
</script>

<template>
  <div class="app-shell">
    <SkipLink />

    <AppHeader />

    <main
      id="main-content"
      class="app-main"
      tabindex="-1"
    >
      <RouterView />
    </main>

    <AppFooter />
  </div>
</template>
