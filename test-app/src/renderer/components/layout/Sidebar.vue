<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { routes } from '@/router'
import { useAppStore } from '@/stores/app'
import { APP_CONFIG } from '@/config/app'
import MacTrafficLights from './MacTrafficLights.vue'

const props = defineProps<{ isMacStyle: boolean }>()

const router = useRouter()
const appStore = useAppStore()
const { t } = useI18n()

const menuItems = computed(() =>
  routes
    .filter((r) => r.meta?.title && r.path !== '/')
    .map((r) => ({
      path: r.path,
      title: r.meta?.titleKey ? t(r.meta.titleKey as string) : (r.meta?.title as string),
      icon: (r.meta?.icon as string) || 'page',
    }))
)

const activePath = computed(() => router.currentRoute.value.path)
function navigateTo(path: string) { router.push(path) }

function hoverBg(e: Event, isActive: boolean) {
  if (!isActive) (e.currentTarget as HTMLElement).style.background = 'var(--color-border-light)'
}
function leaveBg(e: Event, isActive: boolean) {
  if (!isActive) (e.currentTarget as HTMLElement).style.background = ''
}
function hoverLight(e: Event) { (e.currentTarget as HTMLElement).style.background = 'var(--color-border-light)' }
function leaveLight(e: Event) { (e.currentTarget as HTMLElement).style.background = '' }
</script>

<template>
  <div
    class="sidebar-transition flex flex-col h-full glass overflow-hidden"
    :style="{
      width: appStore.sidebarWidth,
      background: 'var(--sidebar-bg)',
      borderRight: '1px solid var(--color-border)',
    }"
  >
    <!-- Top area: macOS traffic lights OR logo -->
    <div class="titlebar-drag flex flex-col flex-shrink-0">
      <!-- macOS: traffic lights row -->
      <div v-if="props.isMacStyle" class="flex items-center h-12 px-4">
        <MacTrafficLights />
      </div>

      <!-- Logo row -->
      <div class="flex items-center px-4" :class="props.isMacStyle ? 'h-10' : 'h-12'">
        <transition name="fade" mode="out-in">
          <div v-if="!appStore.sidebarCollapsed" key="expanded" class="titlebar-no-drag flex items-center gap-2.5 overflow-hidden">
            <div class="w-8 h-8 rounded-[10px] flex items-center justify-center flex-shrink-0 shadow-sm"
              style="background: linear-gradient(135deg, #5996ff, #1549d8)">
              <span class="text-white text-xs font-semibold">{{ APP_CONFIG.name.charAt(0) }}</span>
            </div>
            <span class="text-[13px] font-semibold truncate" :style="{ color: 'var(--color-content)' }">
              {{ APP_CONFIG.name }}
            </span>
          </div>
          <div v-else key="collapsed" class="titlebar-no-drag w-full flex justify-center">
            <div class="w-8 h-8 rounded-[10px] flex items-center justify-center shadow-sm"
              style="background: linear-gradient(135deg, #5996ff, #1549d8)">
              <span class="text-white text-xs font-semibold">{{ APP_CONFIG.name.charAt(0) }}</span>
            </div>
          </div>
        </transition>
      </div>
    </div>

    <!-- Section label -->
    <div v-if="!appStore.sidebarCollapsed" class="px-5 pt-2 pb-1">
      <span class="text-[10px] font-medium uppercase tracking-wider" :style="{ color: 'var(--color-content-tertiary)' }">
        {{ t('menu.navigation') }}
      </span>
    </div>

    <!-- Menu -->
    <nav class="flex-1 overflow-y-auto px-2.5 py-1">
      <button
        v-for="item in menuItems"
        :key="item.path"
        class="w-full flex items-center gap-2.5 px-2.5 h-[34px] rounded-[8px] text-[13px] transition-all duration-150 mb-0.5"
        :style="{
          color: activePath === item.path ? 'var(--color-primary-500)' : 'var(--color-content-secondary)',
          background: activePath === item.path ? 'var(--color-primary-50)' : undefined,
          fontWeight: activePath === item.path ? '500' : undefined,
        }"
        @mouseenter="hoverBg($event, activePath === item.path)"
        @mouseleave="leaveBg($event, activePath === item.path)"
        @click="navigateTo(item.path)"
      >
        <svg class="w-[18px] h-[18px] flex-shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
          <template v-if="item.icon === 'home'">
            <path d="M3 9.5L12 3l9 6.5V20a2 2 0 01-2 2H5a2 2 0 01-2-2V9.5z" />
            <path d="M9 22V12h6v10" />
          </template>
          <template v-else-if="item.icon === 'settings'">
            <circle cx="12" cy="12" r="3" />
            <path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z" />
          </template>
          <template v-else>
            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
            <polyline points="14 2 14 8 20 8" />
          </template>
        </svg>
        <span v-if="!appStore.sidebarCollapsed" class="truncate">{{ item.title }}</span>
      </button>
    </nav>

    <!-- Collapse toggle -->
    <div class="flex-shrink-0 p-2.5">
      <button
        class="w-full h-[34px] flex items-center justify-center rounded-[8px] transition-colors duration-150"
        :style="{ color: 'var(--color-content-tertiary)' }"
        @mouseenter="hoverLight"
        @mouseleave="leaveLight"
        @click="appStore.toggleSidebar"
      >
        <svg class="w-4 h-4 transition-transform duration-200" :style="{ transform: appStore.sidebarCollapsed ? 'rotate(180deg)' : '' }" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round">
          <path d="M15 18l-6-6 6-6" />
        </svg>
      </button>
    </div>
  </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity var(--transition-fast); }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
