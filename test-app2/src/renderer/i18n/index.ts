import { createI18n } from 'vue-i18n'
import zhCN from './locales/zh-CN'
import enUS from './locales/en-US'
import { APP_CONFIG } from '@/config/app'

const i18n = createI18n({
  legacy: false,
  locale: APP_CONFIG.defaultLocale,
  fallbackLocale: 'en-US',
  messages: {
    'zh-CN': zhCN,
    'en-US': enUS
  }
})

export default i18n
