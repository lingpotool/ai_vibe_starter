type EventHandler = (...args: unknown[]) => void

const listeners = new Map<string, Set<EventHandler>>()

/**
 * 渲染进程事件总线 — 零依赖实现
 */
export const eventBus = {
  on(event: string, handler: EventHandler): void {
    if (!listeners.has(event)) listeners.set(event, new Set())
    listeners.get(event)!.add(handler)
  },

  off(event: string, handler: EventHandler): void {
    listeners.get(event)?.delete(handler)
  },

  emit(event: string, ...args: unknown[]): void {
    listeners.get(event)?.forEach((handler) => handler(...args))
  },

  clear(event?: string): void {
    if (event) listeners.delete(event)
    else listeners.clear()
  },
}
