<script setup lang="ts">
import { useTabsStore } from '@/stores/tabs'

const tabsStore = useTabsStore()

function onHover(e: Event, active: boolean) {
  const el = e.currentTarget as HTMLElement
  if (!active) el.style.background = 'var(--color-border-light)'
}
function onLeave(e: Event, active: boolean) {
  const el = e.currentTarget as HTMLElement
  if (!active) el.style.background = ''
}
function onCloseHover(e: Event) {
  (e.currentTarget as HTMLElement).style.background = 'var(--color-border)'
}
function onCloseLeave(e: Event) {
  (e.currentTarget as HTMLElement).style.background = ''
}
</script>

<template>
  <div
    class="flex items-center h-[36px] px-3 gap-1 overflow-x-auto"
    :style="{
      background: 'var(--color-surface-secondary)',
      borderBottom: '1px solid var(--color-border)',
    }"
  >
    <button
      v-for="tab in tabsStore.tabs"
      :key="tab.path"
      class="group flex items-center gap-1.5 px-3 h-[26px] rounded-[6px] text-[12px] whitespace-nowrap transition-all duration-150 flex-shrink-0"
      :style="{
        color: tabsStore.activeTab === tab.path ? 'var(--color-content)' : 'var(--color-content-tertiary)',
        background: tabsStore.activeTab === tab.path ? 'var(--color-surface)' : undefined,
        boxShadow: tabsStore.activeTab === tab.path ? 'var(--shadow-xs)' : undefined,
        fontWeight: tabsStore.activeTab === tab.path ? '500' : undefined,
      }"
      @mouseenter="onHover($event, tabsStore.activeTab === tab.path)"
      @mouseleave="onLeave($event, tabsStore.activeTab === tab.path)"
      @click="tabsStore.switchTab(tab.path)"
    >
      <span>{{ tab.title }}</span>
      <span
        v-if="tab.closable"
        class="w-4 h-4 flex items-center justify-center rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-100"
        @mouseenter="onCloseHover"
        @mouseleave="onCloseLeave"
        @click.stop="tabsStore.removeTab(tab.path)"
      >
        <svg width="7" height="7" viewBox="0 0 7 7" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round">
          <line x1="1" y1="1" x2="6" y2="6" /><line x1="6" y1="1" x2="1" y2="6" />
        </svg>
      </span>
    </button>
  </div>
</template>
