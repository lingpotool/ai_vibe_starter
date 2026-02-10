import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export type PlatformStyle = 'auto' | 'windows' | 'macos'

export const useAppStore = defineStore(
  'app',
  () => {
    const sidebarCollapsed = ref(false)
    const isDark = ref(false)
    const locale = ref<'zh-CN' | 'en-US'>('zh-CN')
    const platformStyle = ref<PlatformStyle>('auto')

    const sidebarWidth = computed(() =>
      sidebarCollapsed.value ? 'var(--sidebar-collapsed-width)' : 'var(--sidebar-width)'
    )

    /** 当前生效的平台风格 */
    const effectivePlatform = computed<'windows' | 'macos'>(() => {
      if (platformStyle.value !== 'auto') return platformStyle.value
      // auto 模式下检测真实平台
      return navigator.userAgent.includes('Macintosh') ? 'macos' : 'windows'
    })

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

    function setPlatformStyle(style: PlatformStyle) {
      platformStyle.value = style
    }

    applyTheme()

    return {
      sidebarCollapsed,
      isDark,
      locale,
      platformStyle,
      sidebarWidth,
      effectivePlatform,
      toggleSidebar,
      toggleTheme,
      setTheme,
      setLocale,
      setPlatformStyle,
    }
  },
  {
    persist: true,
  }
)
