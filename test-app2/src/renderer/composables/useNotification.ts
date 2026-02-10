export function useNotification() {
  return {
    show: (options: { title: string; body: string }) => window.api.system.showNotification(options),
  }
}
