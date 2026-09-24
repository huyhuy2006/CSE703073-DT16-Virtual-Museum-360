import { ref, watchEffect } from 'vue'

const STORAGE_KEY = 'dt16-theme'

function getDefaultTheme() {
  if (typeof window === 'undefined') {
    return 'sang'
  }

  return window.matchMedia(
    '(prefers-color-scheme: dark)',
  ).matches
    ? 'toi'
    : 'sang'
}

const theme = ref(
  localStorage.getItem(STORAGE_KEY) || getDefaultTheme(),
)

export function useTheme() {
  watchEffect(() => {
    document.documentElement.dataset.theme = theme.value
    localStorage.setItem(STORAGE_KEY, theme.value)

    document.cookie =
      `theme=${theme.value}; path=/; max-age=31536000; samesite=lax`
  })

  function toggle() {
    theme.value =
      theme.value === 'sang'
        ? 'toi'
        : 'sang'
  }

  return {
    theme,
    toggle,
  }
}
