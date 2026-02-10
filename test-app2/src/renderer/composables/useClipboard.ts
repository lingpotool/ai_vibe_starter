import { ref, readonly } from 'vue'

export function useClipboard() {
  const text = ref('')

  return {
    text: readonly(text),
    read: async () => {
      text.value = await window.api.system.readClipboard()
      return text.value
    },
    write: (t: string) => window.api.system.writeClipboard(t),
  }
}
