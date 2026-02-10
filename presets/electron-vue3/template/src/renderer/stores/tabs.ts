import { defineStore } from 'pinia'
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import type { RouteLocationNormalized } from 'vue-router'

export interface TabItem {
  path: string
  title: string
  closable: boolean
}

export const useTabsStore = defineStore('tabs', () => {
  const router = useRouter()
  const tabs = ref<TabItem[]>([
    { path: '/home', title: '首页', closable: false }
  ])
  const activeTab = ref('/home')

  function addTab(route: RouteLocationNormalized) {
    const title = (route.meta?.title as string) || '未命名'
    const exists = tabs.value.find((t) => t.path === route.path)
    if (!exists) {
      tabs.value.push({
        path: route.path,
        title,
        closable: route.path !== '/home'
      })
    }
    activeTab.value = route.path
  }

  function removeTab(path: string) {
    const index = tabs.value.findIndex((t) => t.path === path)
    if (index === -1) return

    tabs.value.splice(index, 1)

    if (activeTab.value === path) {
      const nextTab = tabs.value[index] || tabs.value[index - 1]
      if (nextTab) {
        activeTab.value = nextTab.path
        router.push(nextTab.path)
      }
    }
  }

  function switchTab(path: string) {
    activeTab.value = path
    router.push(path)
  }

  return {
    tabs,
    activeTab,
    addTab,
    removeTab,
    switchTab
  }
})
