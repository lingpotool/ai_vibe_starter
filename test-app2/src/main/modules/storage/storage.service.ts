import { app } from 'electron'
import { join } from 'path'
import { readFileSync, writeFileSync, existsSync, mkdirSync } from 'fs'
import { logger } from '../../core/logger'

const STORAGE_FILE = 'app-storage.json'

let data: Record<string, unknown> = {}
let storagePath = ''

export function initStorage(): void {
  const userDataPath = app.getPath('userData')
  storagePath = join(userDataPath, STORAGE_FILE)

  if (existsSync(storagePath)) {
    try {
      const raw = readFileSync(storagePath, 'utf-8')
      data = JSON.parse(raw)
    } catch (error) {
      logger.error('storage', 'Failed to read storage file', error)
      data = {}
    }
  }

  logger.info('storage', `Storage initialized at ${storagePath}`)
}

function save(): void {
  try {
    const dir = join(app.getPath('userData'))
    if (!existsSync(dir)) mkdirSync(dir, { recursive: true })
    writeFileSync(storagePath, JSON.stringify(data, null, 2), 'utf-8')
  } catch (error) {
    logger.error('storage', 'Failed to write storage file', error)
  }
}

export function storageGet(key: string): unknown {
  return data[key]
}

export function storageSet(key: string, value: unknown): void {
  data[key] = value
  save()
}

export function storageDelete(key: string): void {
  delete data[key]
  save()
}

export function storageHas(key: string): boolean {
  return key in data
}
