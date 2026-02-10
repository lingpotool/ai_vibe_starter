import { computed } from 'vue'
import { useAppStore } from '@/stores/app'

export function useTheme() {
  const appStore = useAppStore()

  return {
    isDark: computed(() => appStore.isDark),
    toggle: () => appStore.toggleTheme(),
    set: (dark: boolean) => appStore.setTheme(dark),
  }
}
