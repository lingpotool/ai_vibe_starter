export function useShell() {
  return {
    openExternal: (url: string) => window.api.system.openExternal(url),
    showItemInFolder: (path: string) => window.api.system.showItemInFolder(path),
  }
}
