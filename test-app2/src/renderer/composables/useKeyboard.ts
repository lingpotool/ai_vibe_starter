export function useKeyboard() {
  return {
    register: (accelerator: string, id: string) => window.api.system.registerShortcut(accelerator, id),
    unregister: (id: string) => window.api.system.unregisterShortcut(id),
  }
}
