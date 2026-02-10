<script setup lang="ts">
import { ref, onMounted } from 'vue'

const isMaximized = ref(false)
const isMac = ref(false)
const isHovering = ref(false)

onMounted(async () => {
  try {
    isMaximized.value = await window.api.window.isMaximized()
    isMac.value = (await window.api.system.getPlatform()) === 'darwin'
    window.api.window.onMaximizeChange((maximized: boolean) => {
      isMaximized.value = maximized
    })
  } catch {
    // fallback
  }
})

function minimize() { window.api.window.minimize() }
function maximize() { window.api.window.maximize() }
function close() { window.api.window.close() }
</script>

<template>
  <div
    class="titlebar-drag flex items-center h-[var(--titlebar-height)] select-none relative"
    :style="{ background: 'var(--titlebar-bg)' }"
  >
    <!-- macOS traffic lights area (left) -->
    <div v-if="isMac" class="titlebar-no-drag flex items-center gap-2 pl-4 pr-3 h-full"
      @mouseenter="isHovering = true" @mouseleave="isHovering = false">
      <button class="w-3 h-3 rounded-full bg-[#ff5f57] flex items-center justify-center transition-all hover:brightness-90 active:brightness-75" @click="close">
        <svg v-if="isHovering" width="6" height="6" viewBox="0 0 6 6" fill="none" stroke="#4d0000" stroke-width="1.2">
          <line x1="0.5" y1="0.5" x2="5.5" y2="5.5" /><line x1="5.5" y1="0.5" x2="0.5" y2="5.5" />
        </svg>
      </button>
      <button class="w-3 h-3 rounded-full bg-[#febc2e] flex items-center justify-center transition-all hover:brightness-90 active:brightness-75" @click="minimize">
        <svg v-if="isHovering" width="6" height="1" viewBox="0 0 6 1" fill="#995700"><rect width="6" height="1" /></svg>
      </button>
      <button class="w-3 h-3 rounded-full bg-[#28c840] flex items-center justify-center transition-all hover:brightness-90 active:brightness-75" @click="maximize">
        <svg v-if="isHovering" width="6" height="6" viewBox="0 0 6 6" fill="none" stroke="#006500" stroke-width="0.8">
          <path v-if="!isMaximized" d="M0.5 3.5L0.5 0.5L3.5 0.5M5.5 2.5L5.5 5.5L2.5 5.5" />
          <path v-else d="M1 4L1 1L4 1M5 2L5 5L2 5" />
        </svg>
      </button>
    </div>

    <!-- Spacer for Windows (left side) -->
    <div v-else class="w-3 flex-shrink-0" />

    <!-- Center spacer -->
    <div class="flex-1" />

    <!-- Windows controls (right) -->
    <div v-if="!isMac" class="titlebar-no-drag flex items-center h-full">
      <button
        class="w-[46px] h-full flex items-center justify-center transition-colors duration-100 hover:bg-black/[0.06] dark:hover:bg-white/[0.06]"
        :style="{ color: 'var(--color-content-secondary)' }"
        @click="minimize"
      >
        <svg width="10" height="1" viewBox="0 0 10 1"><rect width="10" height="1" fill="currentColor" rx="0.5" /></svg>
      </button>
      <button
        class="w-[46px] h-full flex items-center justify-center transition-colors duration-100 hover:bg-black/[0.06] dark:hover:bg-white/[0.06]"
        :style="{ color: 'var(--color-content-secondary)' }"
        @click="maximize"
      >
        <svg v-if="!isMaximized" width="10" height="10" viewBox="0 0 10 10" fill="none" stroke="currentColor" stroke-width="1"><rect x="1" y="1" width="8" height="8" rx="1.5" /></svg>
        <svg v-else width="10" height="10" viewBox="0 0 10 10" fill="none" stroke="currentColor" stroke-width="1">
          <rect x="0.5" y="2.5" width="7" height="7" rx="1" />
          <path d="M2.5 2.5V1.5C2.5 0.95 2.95 0.5 3.5 0.5H8.5C9.05 0.5 9.5 0.95 9.5 1.5V6.5C9.5 7.05 9.05 7.5 8.5 7.5H7.5" />
        </svg>
      </button>
      <button
        class="w-[46px] h-full flex items-center justify-center transition-colors duration-100 hover:bg-[#e81123] hover:text-white group"
        :style="{ color: 'var(--color-content-secondary)' }"
        @click="close"
      >
        <svg width="10" height="10" viewBox="0 0 10 10" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round">
          <line x1="1.5" y1="1.5" x2="8.5" y2="8.5" /><line x1="8.5" y1="1.5" x2="1.5" y2="8.5" />
        </svg>
      </button>
    </div>

    <!-- Bottom border -->
    <div class="absolute bottom-0 left-0 right-0 h-px" :style="{ background: 'var(--color-border)' }" />
  </div>
</template>
