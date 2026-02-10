export function useStorage() {
  return {
    get: <T = unknown>(key: string) => window.api.storage.get<T>(key),
    set: (key: string, value: unknown) => window.api.storage.set(key, value),
    remove: (key: string) => window.api.storage.delete(key),
    has: (key: string) => window.api.storage.has(key),
  }
}
