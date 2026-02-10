<script setup lang="ts">
import TitleBar from './TitleBar.vue'
import Sidebar from './Sidebar.vue'
import Topbar from './Topbar.vue'
import TabsBar from './TabsBar.vue'
import { useAppStore } from '@/stores/app'
import { useTabsStore } from '@/stores/tabs'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { watch } from 'vue'

const appStore = useAppStore()
const tabsStore = useTabsStore()
const router = useRouter()
const { locale } = useI18n()

watch(() => appStore.locale, (v) => { locale.value = v }, { immediate: true })
watch(
  () => router.currentRoute.value,
  (route) => { if (route.path !== '/') tabsStore.addTab(route) },
  { immediate: true }
)
</script>

<template>
  <div class="flex flex-col h-screen overflow-hidden" :style="{ background: 'var(--color-surface)' }">
    <!-- Title bar (draggable) -->
    <TitleBar />

    <div class="flex flex-1 overflow-hidden">
      <!-- Sidebar -->
      <Sidebar />

      <!-- Main content area -->
      <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Top bar with breadcrumb + user -->
        <Topbar />

        <!-- Tabs -->
        <TabsBar />

        <!-- Page content -->
        <main
          class="flex-1 overflow-auto"
          :style="{
            padding: 'var(--spacing-page)',
            background: 'var(--color-surface-secondary)',
          }"
        >
          <router-view v-slot="{ Component }">
            <transition name="page" mode="out-in">
              <component :is="Component" />
            </transition>
          </router-view>
        </main>
      </div>
    </div>
  </div>
</template>
