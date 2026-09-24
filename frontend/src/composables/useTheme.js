import { ref, watch } from 'vue'

const KEY = 'dt16-theme'
const AVAILABLE_THEMES = ['sang', 'toi']

function detectDefaultTheme() {
  const saved = localStorage.getItem(KEY)

  if (AVAILABLE_THEMES.includes(saved)) {
    return saved
  }

  if (
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-color-scheme: dark)').matches
  ) {
    return 'toi'
  }

  return 'sang'
}

const theme = ref(detectDefaultTheme())

function applyTheme(value) {
  const safeTheme = AVAILABLE_THEMES.includes(value)
    ? value
    : 'sang'

  document.documentElement.dataset.theme = safeTheme
  localStorage.setItem(KEY, safeTheme)

  document.cookie = [
    `dt16_theme=${safeTheme}`,
    'path=/',
    'max-age=31536000',
    'samesite=lax',
  ].join('; ')
}

watch(
  theme,
  (value) => {
    applyTheme(value)
  },
  { immediate: true },
)

export function useTheme() {
  function toggle() {
    theme.value = theme.value === 'sang'
      ? 'toi'
      : 'sang'
  }

  return {
    theme,
    toggle,
  }
}
