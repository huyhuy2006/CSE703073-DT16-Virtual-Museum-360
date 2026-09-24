<script setup>
import { useTheme } from '../composables/useTheme'

const { theme, toggle } = useTheme()
</script>

<template>
  <button
    class="theme-toggle"
    type="button"
    :aria-pressed="theme === 'toi'"
    :title="
      theme === 'toi'
        ? 'Chuyen sang chu de sang'
        : 'Chuyen sang chu de toi'
    "
    @click="toggle"
  >
    <span aria-hidden="true">
      {{ theme === 'toi' ? '☾' : '☀' }}
    </span>

    <span>
      {{ theme === 'toi' ? 'Giao dien toi' : 'Giao dien sang' }}
    </span>
  </button>
</template>
