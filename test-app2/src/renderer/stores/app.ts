import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useAppStore = defineStore(
  'app',
  () => {
    const isDark = ref(false)
    const locale = ref<'zh-CN' | 'en-US'>('zh-CN')

    /** 真实平台，由主进程告知，不可切换 */
    const platform = ref<'windows' | 'macos' | 'linux'>('windows')

    const isMac = computed(() => platform.value === 'macos')

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
      // Windows: 同步更新 titleBarOverlay 按钮颜色
      updateTitleBarOverlay()
    }

    function updateTitleBarOverlay() {
      if (platform.value !== 'windows') return
      try {
        window.api.window.setTitleBarOverlay({
          color: '#00000000',
          symbolColor: isDark.value ? '#cccccc' : '#555555',
          height: 48,
        })
      } catch { /* 非 Windows 或 API 不可用 */ }
    }

    function setLocale(lang: 'zh-CN' | 'en-US') {
      locale.value = lang
    }

    async function detectPlatform() {
      try {
        const p = await window.api.system.getPlatform()
        if (p === 'darwin') platform.value = 'macos'
        else if (p === 'win32') platform.value = 'windows'
        else platform.value = 'linux'
      } catch {
        // fallback: 通过 userAgent 判断
        platform.value = navigator.userAgent.includes('Macintosh') ? 'macos' : 'windows'
      }
    }

    applyTheme()

    return {
      isDark,
      locale,
      platform,
      isMac,
      toggleTheme,
      setTheme,
      setLocale,
      detectPlatform,
    }
  },
  {
    persist: {
      pick: ['isDark', 'locale'],
    },
  }
)
