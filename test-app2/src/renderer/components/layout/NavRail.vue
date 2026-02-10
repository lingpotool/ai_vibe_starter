<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { routes } from '@/router'
import { useAppStore } from '@/stores/app'
import { cn } from '@/lib/utils'

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

// Tooltip
const tooltip = ref<{ text: string; top: number } | null>(null)
function showTooltip(text: string, e: MouseEvent) {
  const rect = (e.currentTarget as HTMLElement).getBoundingClientRect()
  tooltip.value = { text, top: rect.top + rect.height / 2 - 12 }
}
function hideTooltip() { tooltip.value = null }
</script>

<template>
  <aside
    :class="cn(
      'glass flex w-14 shrink-0 flex-col items-center pb-3 border-r border-sidebar-border',
      appStore.isMac ? 'pt-2' : 'pt-10'
    )"
    :style="{ backgroundColor: 'var(--sidebar)' }"
  >
    <div v-if="appStore.isMac" class="titlebar-drag w-full h-7 shrink-0" />

    <!-- App icon -->
    <button
      class="mb-2 flex h-9 w-9 items-center justify-center rounded-xl
             bg-gradient-to-br from-blue-500 to-indigo-600
             shadow-[0_2px_8px_oklch(0.4_0.2_260/30%)]
             transition-all duration-200 hover:shadow-[0_4px_16px_oklch(0.4_0.2_260/40%)] hover:scale-[1.04] active:scale-95"
      @click="navigateTo('/home')"
      @mouseenter="showTooltip(t('menu.home'), $event)"
      @mouseleave="hideTooltip"
    >
      <svg class="h-4 w-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
      </svg>
    </button>

    <!-- Divider -->
    <div class="mx-auto mb-2 h-px w-6 bg-border/50" />

    <!-- Nav icons -->
    <nav class="flex flex-1 flex-col items-center gap-1">
      <button
        v-for="item in menuItems"
        :key="item.path"
        :class="cn(
          'relative flex h-9 w-9 items-center justify-center rounded-lg transition-all duration-150',
          'text-muted-foreground hover:bg-sidebar-accent hover:text-sidebar-accent-foreground',
          activePath === item.path && 'bg-sidebar-accent text-sidebar-accent-foreground'
        )"
        @click="navigateTo(item.path)"
        @mouseenter="showTooltip(item.title, $event)"
        @mouseleave="hideTooltip"
      >
        <span
          v-if="activePath === item.path"
          class="absolute -left-[7px] h-4 w-[3px] rounded-full bg-sidebar-primary transition-all"
        />
        <svg v-if="item.icon === 'home'" class="h-[18px] w-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <path d="M3 9.5L12 3l9 6.5V20a2 2 0 01-2 2H5a2 2 0 01-2-2V9.5z" />
          <path d="M9 22V12h6v10" />
        </svg>
        <svg v-else-if="item.icon === 'settings'" class="h-[18px] w-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="3" />
          <path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z" />
        </svg>
        <svg v-else class="h-[18px] w-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
          <polyline points="14 2 14 8 20 8" />
        </svg>
      </button>
    </nav>

    <!-- Bottom: theme toggle -->
    <div class="mt-auto flex flex-col items-center gap-2">
      <button
        class="flex h-8 w-8 items-center justify-center rounded-lg text-muted-foreground
               transition-all duration-150 hover:bg-sidebar-accent hover:text-sidebar-accent-foreground"
        @click="appStore.toggleTheme"
        @mouseenter="showTooltip(appStore.isDark ? 'Light mode' : 'Dark mode', $event)"
        @mouseleave="hideTooltip"
      >
        <svg v-if="appStore.isDark" class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round">
          <circle cx="12" cy="12" r="5" />
          <line x1="12" y1="1" x2="12" y2="3" /><line x1="12" y1="21" x2="12" y2="23" />
          <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" /><line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
          <line x1="1" y1="12" x2="3" y2="12" /><line x1="21" y1="12" x2="23" y2="12" />
          <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" /><line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
        </svg>
        <svg v-else class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round">
          <path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z" />
        </svg>
      </button>
    </div>

    <Teleport to="body">
      <div
        v-if="tooltip"
        class="tooltip"
        :style="{ top: tooltip.top + 'px', left: '62px' }"
      >
        {{ tooltip.text }}
      </div>
    </Teleport>
  </aside>
</template>
