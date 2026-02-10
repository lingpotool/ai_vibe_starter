import { EventEmitter } from 'events'

class TypedEventBus {
  private emitter = new EventEmitter()

  emit(event: string, ...args: unknown[]): void {
    this.emitter.emit(event, ...args)
  }

  on(event: string, listener: (...args: unknown[]) => void): void {
    this.emitter.on(event, listener)
  }

  off(event: string, listener: (...args: unknown[]) => void): void {
    this.emitter.off(event, listener)
  }

  once(event: string, listener: (...args: unknown[]) => void): void {
    this.emitter.once(event, listener)
  }
}

export const eventBus = new TypedEventBus()
