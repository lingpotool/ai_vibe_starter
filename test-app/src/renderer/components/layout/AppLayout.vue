<script setup lang="ts">
import Sidebar from './Sidebar.vue'
import Topbar from './Topbar.vue'
import TabsBar from './TabsBar.vue'
import MacTrafficLights from './MacTrafficLights.vue'
import { useAppStore } from '@/stores/app'
import { useTabsStore } from '@/stores/tabs'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { watch, computed } from 'vue'

const appStore = useAppStore()
const tabsStore = useTabsStore()
const router = useRouter()
const { locale } = useI18n()

const isMacStyle = computed(() => appStore.effectivePlatform === 'macos')

watch(() => appStore.locale, (v) => { locale.value = v }, { immediate: true })
watch(
  () => router.currentRoute.value,
  (route) => { if (route.path !== '/') tabsStore.addTab(route) },
  { immediate: true }
)
</script>

<template>
  <div class="flex h-screen overflow-hidden" :style="{ background: 'var(--color-surface)' }">
    <!-- Sidebar (full height) -->
    <Sidebar :is-mac-style="isMacStyle" />

    <!-- Main content area -->
    <div class="flex flex-col flex-1 overflow-hidden">
      <!-- Draggable titlebar region -->
      <div
        class="titlebar-drag w-full shrink-0 flex items-center"
        :class="isMacStyle ? 'h-12' : 'h-12'"
        :style="{ background: 'var(--color-surface)' }"
      />

      <!-- Top bar -->
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
</template>
