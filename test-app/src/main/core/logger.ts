import { app } from 'electron'
import { join } from 'path'
import { appendFileSync, mkdirSync, existsSync } from 'fs'

const isDev = !app.isPackaged

function timestamp(): string {
  return new Date().toISOString().replace('T', ' ').substring(0, 19)
}

function writeToFile(level: string, module: string, message: string): void {
  try {
    const logsDir = join(app.getPath('logs'))
    if (!existsSync(logsDir)) mkdirSync(logsDir, { recursive: true })

    const date = new Date().toISOString().substring(0, 10)
    const logFile = join(logsDir, `${date}.log`)
    const line = `[${timestamp()}] [${level}] [${module}] ${message}\n`
    appendFileSync(logFile, line, 'utf-8')
  } catch {
    // 日志写入失败不应影响应用运行
  }
}

export const logger = {
  info(module: string, message: string): void {
    if (isDev) console.log(`[${timestamp()}] [INFO] [${module}]`, message)
    else writeToFile('INFO', module, message)
  },

  warn(module: string, message: string): void {
    if (isDev) console.warn(`[${timestamp()}] [WARN] [${module}]`, message)
    else writeToFile('WARN', module, message)
  },

  error(module: string, message: string, error?: unknown): void {
    const errorStr = error instanceof Error ? `${error.message}\n${error.stack}` : String(error ?? '')
    if (isDev) console.error(`[${timestamp()}] [ERROR] [${module}]`, message, error ?? '')
    else writeToFile('ERROR', module, `${message} ${errorStr}`)
  },
}
