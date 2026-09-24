<script setup>
import { computed } from 'vue'
import { useTheme } from '../composables/useTheme'

const { theme, toggle } = useTheme()

const buttonLabel = computed(() =>
  theme.value === 'toi'
    ? 'Chuyển sang chủ đề sáng'
    : 'Chuyển sang chủ đề tối',
)
</script>

<template>
  <button
    class="nut nut-phu theme-toggle"
    type="button"
    :aria-pressed="theme === 'toi'"
    :title="buttonLabel"
    @click="toggle"
  >
    <span aria-hidden="true">
      {{ theme === 'toi' ? '☀' : '☾' }}
    </span>

    <span class="theme-toggle-label">
      {{ theme === 'toi' ? 'Sáng' : 'Tối' }}
    </span>

    <span class="sr-only">
      {{ buttonLabel }}
    </span>
  </button>
</template>

<style scoped>
.theme-toggle {
  min-width: 92px;
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
</style>
