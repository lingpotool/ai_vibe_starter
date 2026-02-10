/**
 * 应用配置 — 修改项目名称只需改这里
 * 所有用到项目名、描述的地方都从这里读取
 */
export const APP_CONFIG = {
  /** 应用名称 */
  name: 'My App',
  /** 应用描述 */
  description: 'A beautiful desktop application',
  /** 应用 ID（用于 electron-builder） */
  appId: 'com.app.my-electron-app',
  /** 默认语言 */
  defaultLocale: 'zh-CN' as const,
  /** 支持的语言 */
  supportedLocales: ['zh-CN', 'en-US'] as const
}
