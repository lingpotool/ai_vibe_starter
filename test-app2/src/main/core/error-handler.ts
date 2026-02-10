import { logger } from './logger'

export function initErrorHandler(): void {
  process.on('uncaughtException', (error) => {
    logger.error('process', 'Uncaught exception', error)
  })

  process.on('unhandledRejection', (reason) => {
    logger.error('process', 'Unhandled rejection', reason)
  })
}
