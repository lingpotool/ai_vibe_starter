import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useAppStore = defineStore(
  'app',
  () => {
    const sidebarCollapsed = ref(false)
    const isDark = ref(false)
    const locale = ref<'zh-CN' | 'en-US'>('zh-CN')

    const sidebarWidth = computed(() =>
      sidebarCollapsed.value ? 'var(--sidebar-collapsed-width)' : 'var(--sidebar-width)'
    )

    function toggleSidebar() {
      sidebarCollapsed.value = !sidebarCollapsed.value
    }

    function toggleTheme() {
      isDark.value = !isDark.value
      applyTheme()
    }

    function setTheme(dark: boolean) {
      isDark.value = dark
      applyTheme()
    }

    function applyTheme() {
      if (isDark.value) {
        document.documentElement.classList.add('dark')
      } else {
        document.documentElement.classList.remove('dark')
      }
    }

    function setLocale(lang: 'zh-CN' | 'en-US') {
      locale.value = lang
    }

    // Apply theme on init
    applyTheme()

    return {
      sidebarCollapsed,
      isDark,
      locale,
      sidebarWidth,
      toggleSidebar,
      toggleTheme,
      setTheme,
      setLocale,
    }
  },
  {
    persist: true,
  }
)
