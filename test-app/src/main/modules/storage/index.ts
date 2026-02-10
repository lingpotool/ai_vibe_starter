import { IPC_CHANNELS } from '@shared/constants/ipc-channels'
import { registerHandler } from '../../core/ipc-registry'
import { storageGet, storageSet, storageDelete, storageHas, initStorage } from './storage.service'

export function register(): void {
  const CH = IPC_CHANNELS.STORAGE

  registerHandler(CH.GET, (_event, key: unknown) => {
    return storageGet(key as string)
  })

  registerHandler(CH.SET, (_event, key: unknown, value: unknown) => {
    storageSet(key as string, value)
  })

  registerHandler(CH.DELETE, (_event, key: unknown) => {
    storageDelete(key as string)
  })

  registerHandler(CH.HAS, (_event, key: unknown) => {
    return storageHas(key as string)
  })
}

export function init(): void {
  initStorage()
}
