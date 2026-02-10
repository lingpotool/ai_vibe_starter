<script setup lang="ts">
import { ref } from 'vue'
import { useAppStore } from '@/stores/app'
import { useI18n } from 'vue-i18n'
import Breadcrumb from './Breadcrumb.vue'

const appStore = useAppStore()
const { t } = useI18n()
const showUserMenu = ref(false)

function hoverLight(e: Event) { (e.currentTarget as HTMLElement).style.background = 'var(--color-border-light)' }
function leaveLight(e: Event) { (e.currentTarget as HTMLElement).style.background = '' }
</script>

<template>
  <div
    class="flex items-center justify-between h-11 px-4"
    :style="{
      background: 'var(--color-surface)',
      borderBottom: '1px solid var(--color-border)',
    }"
  >
    <div class="flex items-center gap-3">
      <Breadcrumb />
    </div>

    <div class="flex items-center gap-0.5">
      <!-- Theme toggle -->
      <button
        class="w-8 h-8 flex items-center justify-center rounded-[8px] transition-all duration-150"
        :style="{ color: 'var(--color-content-tertiary)' }"
        :title="appStore.isDark ? t('settings.light') : t('settings.dark')"
        @mouseenter="hoverLight"
        @mouseleave="leaveLight"
        @click="appStore.toggleTheme"
      >
        <svg v-if="!appStore.isDark" class="w-[15px] h-[15px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round">
          <path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z" />
        </svg>
        <svg v-else class="w-[15px] h-[15px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round">
          <circle cx="12" cy="12" r="5" />
          <line x1="12" y1="1" x2="12" y2="3" /><line x1="12" y1="21" x2="12" y2="23" />
          <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" /><line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
          <line x1="1" y1="12" x2="3" y2="12" /><line x1="21" y1="12" x2="23" y2="12" />
          <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" /><line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
        </svg>
      </button>

      <!-- Divider -->
      <div class="w-px h-4 mx-1.5" :style="{ background: 'var(--color-border)' }" />

      <!-- User dropdown -->
      <div class="relative" @mouseleave="showUserMenu = false">
        <button
          class="flex items-center gap-2 px-2 py-1.5 rounded-[8px] transition-all duration-150"
          @mouseenter="hoverLight"
          @mouseleave="leaveLight"
          @click="showUserMenu = !showUserMenu"
        >
          <div class="w-6 h-6 rounded-full flex items-center justify-center"
            style="background: linear-gradient(135deg, #5996ff, #1549d8)">
            <span class="text-white text-[10px] font-medium">U</span>
          </div>
          <span class="text-xs" :style="{ color: 'var(--color-content-secondary)' }">{{ t('user.name') }}</span>
          <svg class="w-3 h-3 transition-transform" :class="showUserMenu ? 'rotate-180' : ''" :style="{ color: 'var(--color-content-tertiary)' }" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M6 9l6 6 6-6" /></svg>
        </button>

        <Transition name="dropdown">
          <div
            v-if="showUserMenu"
            class="absolute right-0 top-full mt-1.5 w-40 rounded-[10px] py-1 z-50"
            :style="{
              background: 'var(--color-surface)',
              border: '1px solid var(--color-border)',
              boxShadow: 'var(--shadow-lg)',
            }"
          >
            <button
              class="w-full text-left px-3 py-2 text-xs transition-colors duration-100"
              :style="{ color: 'var(--color-content-secondary)' }"
              @mouseenter="hoverLight"
              @mouseleave="leaveLight"
              @click="showUserMenu = false"
            >{{ t('user.profile') }}</button>
            <div class="mx-2 my-1" :style="{ borderTop: '1px solid var(--color-border)' }" />
            <button
              class="w-full text-left px-3 py-2 text-xs transition-colors duration-100"
              :style="{ color: 'var(--color-content-secondary)' }"
              @mouseenter="hoverLight"
              @mouseleave="leaveLight"
              @click="showUserMenu = false"
            >{{ t('user.logout') }}</button>
          </div>
        </Transition>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dropdown-enter-active, .dropdown-leave-active {
  transition: opacity 120ms ease, transform 120ms ease;
}
.dropdown-enter-from, .dropdown-leave-to {
  opacity: 0;
  transform: translateY(-4px) scale(0.97);
}
</style>
