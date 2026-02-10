import { createRouter, createWebHashHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

// Auto-import route modules from modules/ directory
const moduleFiles = import.meta.glob('./modules/*.ts', { eager: true })
const moduleRoutes: RouteRecordRaw[] = []

for (const path in moduleFiles) {
  const mod = moduleFiles[path] as { default: RouteRecordRaw[] }
  if (mod.default) {
    moduleRoutes.push(...mod.default)
  }
}

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/home',
  },
  {
    path: '/home',
    name: 'Home',
    component: () => import('@/views/home/index.vue'),
    meta: {
      title: '首页',
      titleKey: 'menu.home',
      icon: 'home',
    },
  },
  ...moduleRoutes,
  {
    path: '/settings',
    name: 'Settings',
    component: () => import('@/views/settings/index.vue'),
    meta: {
      title: '设置',
      titleKey: 'menu.settings',
      icon: 'settings',
    },
  },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

export default router
export { routes }
