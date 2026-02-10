import { ref, computed, onMounted } from 'vue'

export function usePlatform() {
  const platform = ref<string>('win32')

  const isMac = computed(() => platform.value === 'darwin')
  const isWindows = computed(() => platform.value === 'win32')
  const isLinux = computed(() => platform.value === 'linux')

  onMounted(async () => {
    platform.value = await window.api.system.getPlatform()
  })

  return { platform, isMac, isWindows, isLinux }
}
