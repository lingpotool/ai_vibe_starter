import type { App } from 'vue'

/**
 * 渲染进程全局错误处理
 * 注册 Vue errorHandler + window unhandledrejection
 */
export function initErrorHandler(app: App): void {
  // Vue 组件错误
  app.config.errorHandler = (err, instance, info) => {
    console.error('[Vue Error]', info, err)
  }

  // 未捕获的 Promise rejection
  window.addEventListener('unhandledrejection', (event) => {
    console.error('[Unhandled Rejection]', event.reason)
  })
}
