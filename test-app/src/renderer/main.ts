import { createApp } from 'vue'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import 'element-plus/theme-chalk/dark/css-vars.css'
import './assets/styles/index.css'

import App from './App.vue'
import router from './router'
import i18n from './i18n'
import { initErrorHandler } from './core/error-handler'

const app = createApp(App)

// 全局错误处理
initErrorHandler(app)

// Pinia with persistence
const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)

app.use(pinia)
app.use(router)
app.use(i18n)

app.mount('#app')
